using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Messages;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using eventsApp.Services.DogadjajiStateMachine;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class DogadjajiServiceImpl : BaseCRUDService<Model.DogadjajiListResponse, Model.Dogadjaji, Database.Dogadjaji, DogadjajiSearchObject, Model.Requests.DogadjajiInsertRequest, Model.Requests.DogadjajiUpdateRequest>, IDogadjajiService
    {
        public BaseState _baseState { get; set; }

        public ITipKarteService _tipKarteService { get; set; }

        ILogger<DogadjajiServiceImpl> _logger;

        private ISavingService _savingService;

        private IKomentariService _komentariService;

        private IGalerijaService _galerijaService;

        protected readonly IHistorijaPregledaService _historijaPregledaService;
        public DogadjajiServiceImpl(BaseState baseState, EventsDbContext context, IMapper mapper, ILogger<DogadjajiServiceImpl> logger, ITipKarteService tipKarteService, ISavingService savingService, IKomentariService komentariService, IGalerijaService galerijaService, IHistorijaPregledaService historijaPregledaService) : base(context, mapper)
        {
            _baseState = baseState;
            _logger = logger;
            _tipKarteService = tipKarteService;
            _savingService = savingService;
            _komentariService = komentariService;
            _galerijaService = galerijaService;
            _historijaPregledaService = historijaPregledaService;
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
            if (search?.Kategorija != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KategorijaId.Equals(search.Kategorija));
            }
            if (search?.DatumOd != null && search?.DatumDo == null)
            {
                filteredQuery = filteredQuery.Where(x => x.DatumOd >= search.DatumOd || x.DatumDo >= search.DatumOd);
            }
            if (search?.DatumOd == null && search?.DatumDo != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DatumOd <= search.DatumDo && x.DatumDo >= search.DatumDo);
            }
            if (search?.DatumOd != null && search?.DatumDo != null)
            {
                filteredQuery = filteredQuery.Where(x => (x.DatumOd >= search.DatumOd && x.DatumOd <= search.DatumDo) || (x.DatumOd < search.DatumOd && x.DatumDo >= search.DatumOd));
            }
            if (search?.DobavljacId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DobavljacId.Equals(search.DobavljacId));
            }
            if (search?.Podkategorija != null)
            {
                filteredQuery = filteredQuery.Where(x => x.PodkategorijaId.Equals(search.Podkategorija));
            }
            if (search?.Status != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Status.Equals(search.Status));
            }
            if (search?.Username != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Organizator.Equals(search.Username));
            }
          /*  if (search?.Latitude != null && search?.Longitude != null)
            {
                var latitudeParameter = search.Latitude.Value;
                var longitudeParameter = search.Longitude.Value;

                filteredQuery = filteredQuery.Where(x =>
                    CalculateDistance(latitudeParameter, longitudeParameter, x.Latitude, x.Longitude) <= 50);
            }*/

            return filteredQuery;
        }

        public override List<Database.Dogadjaji> FilterResultsAfterDatabaseCall(List<Database.Dogadjaji> dogadjaji, DogadjajiSearchObject? search=null)
        {
            if (search?.Latitude !=null && search?.Longitude!=null)
            {
                var filteredDogadjaji = new List<Database.Dogadjaji>();
                var latitudeParameter = search.Latitude.Value;
                var longitudeParameter = search.Longitude.Value;

                foreach (var d in dogadjaji)
                {
                    if (CalculateDistance(latitudeParameter, longitudeParameter, d.Latitude, d.Longitude) <= 50)
                    {
                        filteredDogadjaji.Add(d);
                    }
                }
               return filteredDogadjaji;
            }
            return dogadjaji;
        }

        private double CalculateDistance(double lat1, double lon1, double lat2, double lon2)
        {
            const double R = 6371;
            double latDistance = DegreesToRadians(lat2 - lat1);
            double lonDistance = DegreesToRadians(lon2 - lon1);

            double a = Math.Sin(latDistance / 2) * Math.Sin(latDistance / 2) +
                       Math.Cos(DegreesToRadians(lat1)) * Math.Cos(DegreesToRadians(lat2)) *
                       Math.Sin(lonDistance / 2) * Math.Sin(lonDistance / 2);

            double c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            return R * c;
        }
        private double DegreesToRadians(double degrees)
        {
            return degrees * Math.PI / 180;
        }

        public override IQueryable<Database.Dogadjaji> AddInclude(IQueryable<Database.Dogadjaji> query, DogadjajiSearchObject? search = null)
        {
            if (search?.KategorijaIncluded == true)
            {
                query = query.Include("Kategorija");
            }
            if (search?.DobavljacIncluded == true)
            {
                query = query.Include("Dobavljac");
            }
            return base.AddInclude(query, search);
        }

        public override Task<Model.Dogadjaji> Insert(DogadjajiInsertRequest insert)
        {
            var state = _baseState.CreateState("INITIAL");
            return state.Insert(insert);
        }

        public override async Task<Database.Dogadjaji> FindEntity(int id)
        {
            return await _context.Set<Database.Dogadjaji>().Include(d => d.Kategorija).FirstOrDefaultAsync(d => d.DogadjajId == id);
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
        public async Task<Model.Dogadjaji> Verify(int id)
        {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);
            return await state.Verify(id);
        }

        public override async Task BeforeDelete(Database.Dogadjaji dogadjaj)
        {
            int dogadjajId = dogadjaj.DogadjajId;

            bool eventHasPictures = await _context.Slikes.Where(s => s.DogadjajId == dogadjajId).AnyAsync();
            if (eventHasPictures) { await _galerijaService.DeleteByDogadjaj(dogadjaj.DogadjajId); }

            bool eventInSaving = await _context.Savings.Where(s => s.DogadjajId == dogadjajId).AnyAsync();
            if (eventInSaving) { await _savingService.DeleteByDogadjaj(dogadjaj.DogadjajId); }

            bool eventHasComments =await  _context.Komentaris.Where(c => c.DogadjajId == dogadjajId).AnyAsync();
            if (eventHasComments) { await _komentariService.DeleteByDogadjaj(dogadjaj.DogadjajId); }

            bool eventInTicketTypes = await _context.TipKartes.Where(s => s.DogadjajId == dogadjajId).AnyAsync();
            if (eventInTicketTypes) { await _tipKarteService.DeleteByDogadjaj(dogadjaj.DogadjajId); }

            bool eventInHistory = await _context.HistorijaPregleda.Where(h => h.DogadjajId == dogadjajId).AnyAsync();
            if (eventInHistory) { await _historijaPregledaService.DeleteByDogadjaj(dogadjaj.DogadjajId); }

        }

        public async Task<Model.Dogadjaji> SendRequestForTickets(int id, List<KarteRequest> request)
        {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);
           return await state.SendRequestForTickets(id,request);
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

        public async Task<List<Model.DogadjajiListResponse>> GetEventsFromFollowingCategories(int korisnikId)
        {
            bool korisnikExists = await _context.Korisnicis.AnyAsync(k => k.KorisnikId == korisnikId);
            if (!korisnikExists)
            {
                throw new Model.UserException("Korisnik nije pronadjen");
            }
            var dogadjajiList = await _context.Korisnicis.Where(k => k.KorisnikId == korisnikId).SelectMany(k => k.Pracenjes).Select(p => p.Kategorija).SelectMany(k => k.Dogadjajis).Include(d => d.Kategorija).OrderByDescending(d => d.Created).ToListAsync();

            return _mapper.Map<List<Model.DogadjajiListResponse>>(dogadjajiList);
        }


        public async Task<Model.PagedResult<DogadjajiListResponse>> FindVerified(BaseSearchObject? search)
        {

            Model.PagedResult<DogadjajiListResponse> result = new Model.PagedResult<DogadjajiListResponse>();

            var query = _context.Dogadjajis.Include(x => x.Dobavljac).Where(x => x.DatumOd >= DateTime.Now || x.DatumDo >= DateTime.Now).Where(x => x.Status == "VERIFIED" || x.Status == "ON_HOLD");

            result.Count = await query.CountAsync();

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }
            var list = await query.ToListAsync();

            result.Result = _mapper.Map<List<DogadjajiListResponse>>(list);

            return result;

        }

        public async Task<HttpResponseMessage> LoadTickets(KarteDobavljacResponseList karteList)
        {
            var entity = await FindEvent(karteList.Dogadjaj, karteList.Datum, karteList.Lokacija);
            if(entity==null) return new HttpResponseMessage(HttpStatusCode.BadRequest);
            var state = _baseState.CreateState(entity.Status);
            return await state.LoadTickets(entity,karteList);
            
        }

        private async Task<Database.Dogadjaji> FindEvent(string naziv, DateTime datum, string lokacija)
        {
            var query = _context.Set<Database.Dogadjaji>();
            return await query.Where(x => x.Naziv == naziv).Where(x => x.DatumOd.Date == datum.Date).Where(x => x.Lokacija == lokacija).SingleOrDefaultAsync();
        }

        public async Task<DogadjajiReportResponse> GetReportData(DogadjajiReportSearchObject? search)
        {
            var response = new DogadjajiReportResponse();
            if (search == null) return response;

            if(search.EventsByStatus!=null && search.EventsByStatus == true)
            {
                response.EventsByStatus = await GetEventsByStatus();
            }
            if (search.EventsByCategory != null && search.EventsByCategory == true)
            {
                response.EventsByCategory = await GetEventsByCategory();
            }
            if (search.TopSellingEvents != null && search.TopSellingEvents == true)
            {
                response.TopSellingEvents = await GetTopSellingEvents();
            }
            if (search.MostViewedEvents != null && search.MostViewedEvents == true)
            {
                response.MostViewedEvents = await _historijaPregledaService.GetMostViewedEvents();
            }
            if (search.MostSavedEvents != null && search.MostSavedEvents == true)
            {
                response.MostSavedEvents = await _savingService.GetMostSavedEvents();
            }
            return response;
        }

        private async Task<List<Dictionary<string,object>>> GetEventsByStatus()
        {
            var queryResult = await _context.Dogadjajis.GroupBy(d => d.Status).Select(group => new
             {
                Status = group.Key,
                Count = group.Count()
              }).ToListAsync();

            return queryResult.Select(item => new Dictionary<string, object>{ { "status", item.Status }, {"count",item.Count }}).ToList();
        }

        private async Task<List<Dictionary<string, object>>> GetEventsByCategory()
        {
            var queryResult = await _context.Dogadjajis.GroupBy(d => d.KategorijaId).Select(group => new
            {
                KategorijaId = group.Key,
                Count = group.Count()
            }).ToListAsync();

            return queryResult
                .Join(_context.Kategorijes,
                      grouped => grouped.KategorijaId,
                      kategorija => kategorija.KategorijaId,
                      (grouped, kategorija) => new
                      {
                          Kategorija = kategorija.Naziv,
                          grouped.Count
                      }).Select(item => new Dictionary<string, object> { { "kategorija", item.Kategorija },
        { "count", item.Count } }).ToList();
        }

        private async Task<List<Dictionary<string, object>>> GetTopSellingEvents()
        {

            var top3Revenue = await _context.Dogadjajis
                .Join(
                    _context.TipKartes,
                    dogadjaj => dogadjaj.DogadjajId,
                    tipKarte => tipKarte.DogadjajId,
                    (dogadjaj, tipKarte) => new { dogadjaj, tipKarte }
                )
                .Join(
                    _context.NarudzbaStavkes,
                    joined => joined.tipKarte.TipKarteId,
                    narudzbaStavka => narudzbaStavka.TipKarteId,
                    (joined, narudzbaStavka) => new
                    {
                        joined.dogadjaj.DogadjajId,
                        joined.dogadjaj.Naziv,
                        Revenue = narudzbaStavka.Cijena
                    }
                )
                .GroupBy(x => new { x.DogadjajId, x.Naziv })
                .Select(group => new
                {
                    group.Key.DogadjajId,
                    group.Key.Naziv,
                    Revenue = group.Sum(x => x.Revenue)
                })
                .OrderByDescending(x => x.Revenue)
                .Take(3)
                .ToListAsync();

 
            var top3DogadjajIds = top3Revenue.Select(x => x.DogadjajId).ToList();

            var karteData = await _context.Dogadjajis
                .Join(
                    _context.TipKartes,
                    dogadjaj => dogadjaj.DogadjajId,
                    tipKarte => tipKarte.DogadjajId,
                    (dogadjaj, tipKarte) => new { dogadjaj, tipKarte }
                )
                .Join(
                    _context.NarudzbaStavkes,
                    joined => joined.tipKarte.TipKarteId,
                    narudzbaStavka => narudzbaStavka.TipKarteId,
                    (joined, narudzbaStavka) => new
                    {
                        joined.dogadjaj.DogadjajId,
                        joined.dogadjaj.Naziv,
                        TicketCount = narudzbaStavka.Kolicina
                    }
                )
                .Where(x => top3DogadjajIds.Contains(x.DogadjajId))
                .GroupBy(x => new { x.DogadjajId, x.Naziv })
                .Select(group => new
                {
                    group.Key.Naziv,
                    TicketCount = group.Sum(x => x.TicketCount)
                })
                .ToListAsync();

            var result = top3Revenue.Select(prihod => new Dictionary<string, object>{
            { "type", "Prihod" },
            { "dogadjaj", prihod.Naziv },
            { "value", prihod.Revenue }
                })
                .Concat(
                    karteData.Select(karte => new Dictionary<string, object>
                    {
                { "type", "Karte" },
                { "dogadjaj", karte.Naziv },
                { "value", karte.TicketCount }
                    })
                )
                .ToList();

            return result;
        }

        public override async Task WriteInHistory(int? korisnikId, int? dogadjajId)
        {
            await _historijaPregledaService.Create(korisnikId, dogadjajId);
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
