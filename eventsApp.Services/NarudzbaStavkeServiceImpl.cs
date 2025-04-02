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
    public class NarudzbaStavkeServiceImpl : INarudzbaStavkeService
    {
        protected readonly ILogger<NarudzbaStavkeServiceImpl> _logger;
        protected readonly EventsDbContext _context;
        protected IMapper _mapper;
        public NarudzbaStavkeServiceImpl(EventsDbContext context, IMapper mapper, ILogger<NarudzbaStavkeServiceImpl> logger)
        {
            _logger = logger;
            _context = context;
            _mapper = mapper;
        }

        public async Task<string> CreateNarudzbaStavke(List<ValidTipKarte> request, int narudzbaId)
        {
            if (request == null || request.Count() == 0) throw new UserException("Lista kartata je obavezna");

            var set = _context.Set<Database.NarudzbaStavke>();

            foreach (ValidTipKarte validTipKarte in request)
            {
                Database.NarudzbaStavke stavka= _mapper.Map<Database.NarudzbaStavke>(validTipKarte);
                stavka.NarudzbaId = narudzbaId;
                set.Add(stavka);
            }

            await _context.SaveChangesAsync();
            return "OK";
        }
    }
}
