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
        public NarudzbaServiceImpl(EventsDbContext context, IMapper mapper, ILogger<NarudzbaServiceImpl> logger, ITipKarteService tipKarteService, INarudzbaStavkeService narudzbaStavkeService)
        {
            _logger = logger;
            _tipKarteService = tipKarteService;
            _context = context;
            _mapper = mapper;
            _narudzbaStavkeService = narudzbaStavkeService;
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

                Database.Narudzbe narudzbaEntity = _mapper.Map<Database.Narudzbe>(request);

                narudzbaEntity.BrojNarudzbe = Guid.NewGuid().ToString("N").Substring(0, 9).ToUpper();
                narudzbaEntity.Datum = DateTime.Now;

                set.Add(narudzbaEntity);
                await _context.SaveChangesAsync();

                await _narudzbaStavkeService.CreateNarudzbaStavke(request.ListaKarata, narudzbaEntity.NarudzbaId);

                await transaction.CommitAsync();

                return _mapper.Map<Model.Narudzbe>(narudzbaEntity);
            } catch(Exception e)
            {
                await transaction.RollbackAsync();
                throw new Exception("Neuspjesno kreiranje narudzbe:", e);
            }
        }



    }
}
