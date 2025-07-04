using AutoMapper;
using eventsApp.Model;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.ML;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class RecommenderSystemServiceImpl : IRecommenderSystemService
    {
        ILogger<RecommenderSystemServiceImpl> _logger;

        protected Timer _timer;

        protected EventsDbContext _context;

        private readonly IDogadjajiService _dogadjajiService;

        private readonly IMapper _mapper;

        public RecommenderSystemServiceImpl(ILogger<RecommenderSystemServiceImpl> logger, EventsDbContext context, IDogadjajiService dogadjajiService, IMapper mapper)
        {
            _logger = logger;
            _context = context;
            _dogadjajiService = dogadjajiService;
            _mapper = mapper;
            _logger.LogInformation(" RecommenderSystemServiceImpl instantiated.");
            ScheduleDailyTask();
        }

        private void ScheduleDailyTask()
        {
            var now = DateTime.Now;
            var targetTime = DateTime.Today.AddDays(1);
            var initialDelay = (targetTime - now).TotalMilliseconds;

            _timer = new Timer(async state =>
            {
                try
                {
                  await CreateModel();
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Error whil training model: {ex.Message}", ex);
                }
            }, null, (long)initialDelay, TimeSpan.FromDays(1).Milliseconds);
        }

        public async Task<ITransformer> CreateModel()
        {
            _logger.LogInformation("Model creation started...");

            var mlContext = new MLContext();

            var interactions = await GetData();

            if (!interactions.Any()) {
                _logger.LogWarning("No interaction data available. Skipping model training.");
                return null;
            }

            var trainData = mlContext.Data.LoadFromEnumerable(interactions);
            var trainTestSplit = mlContext.Data.TrainTestSplit(trainData, testFraction: 0.2);
            var testData = trainTestSplit.TestSet;

            var options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = "UserIdEncoded",
                MatrixRowIndexColumnName = "EventIdEncoded",
                LabelColumnName = "InteractionScore",
                LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass,
                Alpha = 0.01,
                Lambda = 0.025,
                NumberOfIterations = 20,
                ApproximationRank = 20
            };

            var pipeline = mlContext.Transforms.Conversion.MapValueToKey(outputColumnName: "UserIdEncoded", inputColumnName: "UserId")
                .Append(mlContext.Transforms.Conversion.MapValueToKey(outputColumnName: "EventIdEncoded", inputColumnName: "EventId"))
                .Append(mlContext.Recommendation().Trainers.MatrixFactorization(options));

            var model = pipeline.Fit(trainTestSplit.TrainSet);
            if (model == null)
            {
                throw new Exception("Model training failed, resulting model is null.");
            }

            _logger.LogInformation("Model creation ended");


            _logger.LogInformation("Model evaluation started...");
            var prediction = model.Transform(testData);
            var metrics = mlContext.Regression.Evaluate(prediction, labelColumnName: "InteractionScore", scoreColumnName: "Score");

            Console.WriteLine("Root Mean Squared Error : " + metrics.RootMeanSquaredError.ToString());
            Console.WriteLine("RSquared: " + metrics.RSquared.ToString());
            _logger.LogInformation("Model evaluation ended.");


            _logger.LogInformation("Save model started...");
            await SaveModelToDatabase(mlContext, trainData.Schema, model);
            _logger.LogInformation("Save model ended.");
            return model;
        }

        public async Task SaveModelToDatabase(MLContext mlContext, DataViewSchema schema, ITransformer model)
        {
            using (var memoryStream = new MemoryStream())
            {
                mlContext.Model.Save(model, schema, memoryStream);
                byte[] modelBytes = memoryStream.ToArray();

                    var modelEntity = new TrainedModel
                    {
                        ModelData = modelBytes,
                        Created = DateTime.Now
                    };

                    _context.TrainedModels.Add(modelEntity);
                    await _context.SaveChangesAsync();
            }
            
        }


        private async  Task<List<EventInteraction>> GetData()
        {
            var data = new List<EventInteraction>();

            var savedEvents = await _context.Savings
               .Select(se => new EventInteraction
               {
                   UserId = (uint)se.KorisnikId,
                   EventId = (uint)se.DogadjajId,
                   InteractionScore = 4.0f
               }).ToListAsync();
            data.AddRange(savedEvents);

            var viewedEvents = await _context.HistorijaPregleda
                .Select(ve => new EventInteraction
                {
                    UserId = (uint)ve.KorisnikId,
                    EventId = (uint)ve.DogadjajId,
                    InteractionScore = 1.0f
                }).ToListAsync();
            data.AddRange(viewedEvents);

            var ticketPurchases = await _context.Narudzbes.Include(n => n.NarudzbaStavkes).ThenInclude(ns => ns.TipKarte)
           .Where(n => n.NarudzbaStavkes.Any()).Select(n => new EventInteraction
           {
               UserId = (uint)n.KorisnikId,
               EventId = (uint)(n.NarudzbaStavkes.First().TipKarte.DogadjajId ?? 0),
               InteractionScore = 5.0f
           }).ToListAsync();
            data.AddRange(ticketPurchases);

            var commentedEvents = await _context.Komentaris
                .Select(c => new EventInteraction
                {
                    UserId = (uint)c.KorisnikId,
                    EventId = (uint)c.DogadjajId,
                    InteractionScore = 3.0f
                }).ToListAsync();
            data.AddRange(commentedEvents);

            return data;
        }

        public async Task<List<DogadjajiListResponse>> Recommend(int userId)
        {
            var user = await _context.Korisnicis
               .Include(k=>k.HistorijaPregleda)
               .SingleOrDefaultAsync(k => k.KorisnikId == userId);

            if (user == null) throw new Exception("Korisnik ne postoji");

            if (!user.HistorijaPregleda.Any())
            {
                return await _dogadjajiService.GetMostPopularEvents();
            }

            var mlContext = new MLContext();

            var model = await LoadModel(mlContext);

            if (model == null)
            {
                model = await CreateModel();
                if(model==null) return await _dogadjajiService.GetMostPopularEvents();
            }

            var recommendedEventsEntities = await RecommendEvents(mlContext, model, userId);

            return _mapper.Map<List<DogadjajiListResponse>>(recommendedEventsEntities);
        }

        private async Task<ITransformer> LoadModel(MLContext mlContext)
        {
            var modelEntity= await _context.TrainedModels.OrderByDescending(m => m.Created).FirstOrDefaultAsync();
            if (modelEntity == null || modelEntity.ModelData == null) return null;

            using var memoryStream = new MemoryStream(modelEntity.ModelData);

            var trainedModel = mlContext.Model.Load(memoryStream, out var modelSchema);

            return trainedModel;
        }

        private async Task<List<Database.Dogadjaji>> RecommendEvents(MLContext mlContext, ITransformer model, int userId)
        {
            var predictionEngine = mlContext.Model.CreatePredictionEngine<EventInteraction, EventPrediction>(model);

            var possibleEvents = await _context.Dogadjajis.Include(d=>d.Kategorija).Include(d => d.TipKartes).ThenInclude(t => t.NarudzbaStavkes).ThenInclude(n => n.Narudzba)
                .Where(d => d.Status == "ACTIVE" &&
                     !d.TipKartes.Any(t => t.NarudzbaStavkes.Any(n => n.Narudzba.KorisnikId == userId))).ToListAsync();
            if (!possibleEvents.Any()) throw new Exception("Ne postoje događaji za predložiti");

            var predictionList = new List<Tuple<Database.Dogadjaji, float>>();

            foreach (var e in possibleEvents)
            {
                var input = new EventInteraction { UserId = (uint)userId, EventId = (uint)e.DogadjajId };
                var prediction = predictionEngine.Predict(input);
                Console.WriteLine($"User id {userId} event prediction : event id {e.DogadjajId}\nScore: {prediction.Score}");

                predictionList.Add(new Tuple<Database.Dogadjaji,float>(e,prediction.Score));
            }

            return predictionList
                .OrderByDescending(p => p.Item2)
                .Take(3)
                .Select(p => p.Item1)
                .ToList();
        }

    }
}

public class EventInteraction
{
    public uint UserId { get; set; }
    public uint EventId { get; set; }
    public float InteractionScore { get; set; }
}

public class EventPrediction
{
    public float Score;
}

