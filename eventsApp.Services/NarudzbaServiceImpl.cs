using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Stripe;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class NarudzbaServiceImpl:BaseService<Model.Narudzbe, Model.Narudzbe, Database.Narudzbe, NarudzbaSearchObject>, INarudzbaService
    {
        protected readonly ILogger<NarudzbaServiceImpl> _logger;
        protected readonly ITipKarteService _tipKarteService;
        protected readonly INarudzbaStavkeService _narudzbaStavkeService;
        protected readonly IKarteService _karteService;
        protected readonly INotificationService _notificationService;
        private readonly string stripeSecretKey;
        public NarudzbaServiceImpl(EventsDbContext context, IMapper mapper, ILogger<NarudzbaServiceImpl> logger, ITipKarteService tipKarteService, INarudzbaStavkeService narudzbaStavkeService, IKarteService karteService, INotificationService notificationService, IConfiguration configuration) :base(context,mapper)
        {
            _logger = logger;
            _tipKarteService = tipKarteService;
            _narudzbaStavkeService = narudzbaStavkeService;
            _karteService = karteService;
            _notificationService = notificationService;
          //  stripeSecretKey = configuration["StripeSettings:ApiKey"] ?? Environment.GetEnvironmentVariable("STRIPE_API_KEY");
            stripeSecretKey = configuration["Stripe:SecretKey"] ?? Environment.GetEnvironmentVariable("STRIPE_API_KEY");
        }

        public async Task<List<Model.ValidTipKarte>> ValidateRequest(Dictionary<int, int> request)
        {
            List<ValidTipKarte> response = new List<ValidTipKarte>();
            foreach(var item in request)
            {
                var tipKarte = await _tipKarteService.TicketsAvailable(item.Key, item.Value);
                response.Add(new ValidTipKarte { TipKarteId=tipKarte.TipKarteId, Naziv=tipKarte.Naziv, Kolicina=item.Value, Cijena=item.Value*tipKarte.Cijena});
            }
            return response;
        }

        public async Task<String> CreatePaymentIntent(PaymentIntentRequest request)
        {
            StripeConfiguration.ApiKey = stripeSecretKey;

            try
            {
                var options = new PaymentIntentCreateOptions
                {
                    Amount = request.Amount,
                    Currency = request.Currency,
                    AutomaticPaymentMethods = new PaymentIntentAutomaticPaymentMethodsOptions
                    {
                        Enabled = true,
                    },
                };

                // Create the payment intent
                var service = new PaymentIntentService();
                var paymentIntent = await service.CreateAsync(options);

                // Map the Stripe PaymentIntent to your model
                /*return new Model.PaymentIntent
                {
                    ClientSecret = paymentIntent.ClientSecret,
                    PaymentIntentId = paymentIntent.Id,
                };*/
                //return paymentIntent.Id;
                return paymentIntent.ClientSecret;
            }
            catch (Exception ex)
            {
                // Log the error (you can use _logger here if needed)
                _logger.LogError(ex, "Error creating PaymentIntent");

                // Re-throw or handle the exception
                throw new Exception("Error creating PaymentIntent", ex);
            }
        }

        public async Task<Model.Narudzbe> CreateNarudzba(NarudzbaInsertRequest request)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var set = _context.Set<Database.Narudzbe>();

                var dogadjaj = await _tipKarteService.GetDogadjajByTipKarte(request.ListaKarata[0].TipKarteId);

                Database.Narudzbe narudzbaEntity = _mapper.Map<Database.Narudzbe>(request);

                narudzbaEntity.BrojNarudzbe = Guid.NewGuid().ToString("N").Substring(0, 9).ToUpper();
                narudzbaEntity.Datum = DateTime.Now;

                set.Add(narudzbaEntity);
                await _context.SaveChangesAsync();

                await _narudzbaStavkeService.CreateNarudzbaStavke(request.ListaKarata, narudzbaEntity.NarudzbaId);

                await _tipKarteService.UpdateStanjeOduzmi(request.ListaKarata);

                var karte = await _karteService.NaruciKarte(request.ListaKarata);

                await transaction.CommitAsync();

                var narudzba = _mapper.Map<Model.Narudzbe>(narudzbaEntity);

                _notificationService.SendOrderMail(dogadjaj, narudzba, request.ListaKarata, karte);

                return narudzba;
            } catch(Exception e)
            {
                await transaction.RollbackAsync();
                throw new Exception("Neuspjesno kreiranje narudzbe:", e);
            }
        }

        public async Task<List<Model.Dogadjaji>> GetNarudzbeDogadjaji(NarudzbaDogaadjajSearchObject? search)
        {
            var result = new List<Model.Dogadjaji>();
            var query = _context.Set<Database.Narudzbe>().AsQueryable();

            if (search?.OrderBy == "Datum")
            {
                 query = query.OrderBy(n => n.Datum);
            }


            if (search?.KorisnikId!=null)
            {
                /*var dogadjajiEntities = query.Where(n => n.KorisnikId == search.KorisnikId)
               .Include(n => n.NarudzbaStavkes).ThenInclude(ns => ns.TipKarte).ThenInclude(tk => tk.Dogadjaj)
               .ThenInclude(d => d.Kategorija).SelectMany(n => n.NarudzbaStavkes).Select(ns => ns.TipKarte.Dogadjaj);*/

                var dogadjajiEntities = await query.Where(n => n.KorisnikId == search.KorisnikId)
                    .Include(n => n.NarudzbaStavkes).ThenInclude(ns => ns.TipKarte).ThenInclude(tk => tk.Dogadjaj)
                    .ThenInclude(d => d.Kategorija).SelectMany(n => n.NarudzbaStavkes)
                    .Select(ns => ns.TipKarte.Dogadjaj).ToListAsync();

                var distinctDogadjaji = dogadjajiEntities.GroupBy(d => d.DogadjajId).Select(g => g.First()).ToList();

                result =_mapper.Map<List<Model.Dogadjaji>>(dogadjajiEntities);

            }
            return result;
        }

        public async Task<List<Dictionary<string, object>>> GetMostOrdersUsers()
        {
            var query = await _context.Narudzbes
                .GroupBy(n => n.KorisnikId)
                .Select(group => new
                {
                    KorisnikId = group.Key,
                    OrdersCount = group.Count()
                })
                .OrderByDescending(x => x.OrdersCount)
                .Take(3)
                .ToListAsync();

            var names = await _context.Korisnicis
                .Where(k => query.Select(s => s.KorisnikId).Contains(k.KorisnikId))
                .Select(k => new
                {
                    k.KorisnikId,
                    k.Ime
                })
                .ToListAsync();

            return query
                .Join(names,
                      topSubscriber => topSubscriber.KorisnikId,
                      subscriber => subscriber.KorisnikId,
                      (topSubscriber, subscriber) => new Dictionary<string, object>
                      {
                  { "korisnik", subscriber.Ime },
                  { "narudzbe", topSubscriber.OrdersCount }
                      })
                .ToList();
        }

        public async Task<Model.NarudzbeReportResponse> GetReportData(NarudzbeReportSearchObject? search)
        {
            var response = new Model.NarudzbeReportResponse();
            if (search == null) return response;

            if (search.NumOfOrders != null && search.NumOfOrders == true)
            {
                response.NumOfOrders = await GetNumOfOrders();
            }
            if (search.Revenue != null && search.Revenue == true)
            {
                response.Revenue = await GetRevenue();
            }
            if (search.NumOfSoldTickets != null && search.NumOfSoldTickets == true)
            {
                response.NumOfSoldTickets = await _narudzbaStavkeService.GetNumOfSoldTickets();
            }
            if (search.MostSoldEvents != null && search.MostSoldEvents == true)
            {
                response.MostSoldEvents = await _narudzbaStavkeService.GetMostSoldEvents();
            }
            return response;
        }

        private async Task<List<Dictionary<string, object>>> GetNumOfOrders()
        {
            var oneMonthAgo = DateTime.Now.AddMonths(-1);

            var totalOrdersCount = await _context.Narudzbes.CountAsync();
            var lastMonthOrdersCount = await _context.Narudzbes
                .Where(n => n.Datum >= oneMonthAgo)
                .CountAsync();

            return new List<Dictionary<string, object>>{
        new Dictionary<string, object>
        {
            { "time", "Month" },
            { "narudzbe", lastMonthOrdersCount }
        },
        new Dictionary<string, object>
        {
            { "time", "All time" },
            { "narudzbe", totalOrdersCount }
        }
    };

        }

        private async Task<List<Dictionary<string, object>>> GetRevenue()
        {
            var oneMonthAgo = DateTime.Now.AddMonths(-1);

            var totalRevenue = await _context.Narudzbes
                .SumAsync(n => n.Cijena);
            var lastMonthRevenue = await _context.Narudzbes
                .Where(n => n.Datum >= oneMonthAgo)
                .SumAsync(n => n.Cijena);

            return new List<Dictionary<string, object>>
    {
        new Dictionary<string, object>
        {
            { "time", "Month" },
            { "revenue", lastMonthRevenue }
        },
        new Dictionary<string, object>
        {
            { "time", "All time" },
            { "revenue", totalRevenue }
        }
    };
        }

        public override IQueryable<Database.Narudzbe> AddFilter(IQueryable<Database.Narudzbe> query, NarudzbaSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.BrojNarudzbe))
            {
                query = query.Where(x => x.BrojNarudzbe.Contains(search.BrojNarudzbe));
            }
            if (!string.IsNullOrWhiteSpace(search?.Username))
            {
                query = query.Where(x => x.Korisnik.KorisnickoIme.Contains(search.Username));
            }
            if (search?.Datum != null)
            {
                var startOfDay = search.Datum.Value.Date;
                var endOfDay = startOfDay.AddDays(1).AddTicks(-1);
                query = query.Where(x => x.Datum >= startOfDay && x.Datum <= endOfDay);
            }


            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.Narudzbe> AddInclude(IQueryable<Database.Narudzbe> query, NarudzbaSearchObject? search = null)
        {
            query = query.Include(k => k.Korisnik);
            return base.AddInclude(query, search);
        }
    }


}
