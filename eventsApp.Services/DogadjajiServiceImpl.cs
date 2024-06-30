using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using eventsApp.Services.DogadjajiStateMachine;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class DogadjajiServiceImpl : BaseCRUDService<Model.DogadjajiListResponse, Model.Dogadjaji, Database.Dogadjaji, DogadjajiSearchObject, Model.Requests.DogadjajiInsertRequest, Model.Requests.DogadjajiUpdateRequest>, IDogadjajiService
    {
        public BaseState _baseState { get; set; }

        ILogger<DogadjajiServiceImpl> _logger;
        public DogadjajiServiceImpl(BaseState baseState, EventsDbContext context, IMapper mapper, ILogger<DogadjajiServiceImpl> logger) : base(context, mapper)
        {
            _baseState = baseState;
            _logger = logger;
        }

        public override IQueryable<Database.Dogadjaji> AddFilter(IQueryable<Database.Dogadjaji> query, DogadjajiSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
            if (!string.IsNullOrWhiteSpace(search?.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.FTS));
            }
            if (!string.IsNullOrWhiteSpace(search?.Lokacija))
            {
                filteredQuery = filteredQuery.Where(x => x.Lokacija.Contains(search.Lokacija));
            }
            if (search?.Kategorija!=null)
            {
                filteredQuery = filteredQuery.Where(x => x.KategorijaId.Equals(search.Kategorija));
            }
            if (search?.DatumOd != null && search?.DatumDo==null)
            {
                filteredQuery = filteredQuery.Where(x => x.DatumOd>=(search.DatumOd));
            }
            if (search?.DatumOd==null && search?.DatumDo != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DatumOd<=(search.DatumDo));
            }
            if(search?.DatumOd!=null && search?.DatumDo!=null)
            {
                filteredQuery = filteredQuery.Where(x => x.DatumOd >= (search.DatumOd)).Where(x=>x.DatumOd<=search.DatumDo);
            }
            if (search?.DobavljacId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DobavljacId.Equals(search.DobavljacId));
            }
            return filteredQuery;
        }

        public override Task<Model.Dogadjaji> Insert(DogadjajiInsertRequest insert)
        {
            var state = _baseState.CreateState("INITIAL");
            return state.Insert(insert);
        }

        public override async Task<Model.Dogadjaji> Update(int id, DogadjajiUpdateRequest update)
        {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);
            return await state.Update(id, update);
        }

        public async Task<Model.Dogadjaji> Activate(int id)
        {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);
            return await state.Activate(id);
        }

        public async Task<Model.Dogadjaji> Hide(int id)
        {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);
            return await state.Hide(id);
        }

        public async Task<List<string>> AllowedActions(int id) {
            _logger.LogInformation($"Allowed actions called for id {id}");
            if (id <= 0)
            {
                var state = _baseState.CreateState("INITIAL");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = await _context.Dogadjajis.FindAsync(id);
                var state = _baseState.CreateState(entity?.Status);
                return state.AllowedActions(entity);
            }
        }

       /* static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Model.Dogadjaji> Recommend(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    var tmpData = _context.Narudzbes.Include("NarudzbaStavkes").ToList();
                    var data = new List<ProductEntry>();

                    foreach(var x in tmpData)
                    {
                        if (x.NarudzbaStavkes.Count > 1)
                        {
                            var distinctItemId = x.NarudzbaStavkes.Select(y => y.Id).ToList();//??

                            distinctItemId.forEach(y =>
                            {
                                var relatedItems = x.NarudzbaStavkes.Where(z => z.Id != y);

                                foreach(var z in relatedItems)
                                {
                                    data.Add(new ProductEntry()
                                    {
                                        ProductID = (uint)y,
                                        CoPurchaseProductID = (uint)z.Id
                                    });
                                }
                            });
                        }
                    }

                    var trainData = mlContext.Data.LoadFromEnumerable(data);

                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(ProductEntry.ProductID);
                    options.MatrixRowIndexColumnName=nameof(ProductEntry.CoPurchaseProductID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);

                    model=est.Fit(trainData);
                }
            }

            var products = _context.Dogadjajis.Where(x => x.DogadjajId != id);
            var predictionResult = new List<Tuple<Database.Dogadjaji, float>>();

            foreach(var product in products)
            {
                var predictionEngine = mlContext.Model.CreatePredictionEngine<ProductEntry, Copurchase_prediction>(model);
                var prediction = predictionEngine.Predict(new ProductEntry()
                {
                    ProductID = (uint)id,
                    CoPurchaseProductID = (uint)product.DogadjajId
                });

                predictionResult.Add(new Tuple<Database.Dogadjaji, float>(product, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();
            return _mapper.Map<List<Model.Dogadjaji>>(finalResult);
        }*/

    }

    /*public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class ProductEntry{
        [KeyType(count:10)]
        public uint ProductID { get; set; }

        [KeyType(count:10)]
        public uint CoPurchaseProductID { get; set; }

        public float Label { get; set; }
    }*/
}
