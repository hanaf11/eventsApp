using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Services.Database;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class NarudzbaServiceImpl:INarudzbaService
    {
        protected readonly ILogger<NarudzbaServiceImpl> _logger;
        protected readonly ITipKarteService _tipKarteService;
        protected readonly EventsDbContext _context;
        protected IMapper _mapper;
        protected readonly INarudzbaStavkeService _narudzbaStavkeService;
        protected readonly IKarteService _karteService;
        protected readonly INotificationService _notificationService;
        public NarudzbaServiceImpl(EventsDbContext context, IMapper mapper, ILogger<NarudzbaServiceImpl> logger, ITipKarteService tipKarteService, INarudzbaStavkeService narudzbaStavkeService, IKarteService karteService, INotificationService notificationService)
        {
            _logger = logger;
            _tipKarteService = tipKarteService;
            _context = context;
            _mapper = mapper;
            _narudzbaStavkeService = narudzbaStavkeService;
            _karteService = karteService;
            _notificationService = notificationService;
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



    }
}
