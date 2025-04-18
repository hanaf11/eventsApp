using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
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

        public async Task<List<Dictionary<string, object>>> GetNumOfSoldTickets()
        {
            var oneMonthAgo = DateTime.Now.AddMonths(-1);

            var totalTicketsSold = await _context.NarudzbaStavkes
                .SumAsync(ns => ns.Kolicina);
            var lastMonthTicketsSold = await _context.NarudzbaStavkes
                .Where(ns => ns.Narudzba.Datum >= oneMonthAgo)
                .SumAsync(ns => ns.Kolicina);

            return new List<Dictionary<string, object>>
    {
        new Dictionary<string, object>
        {
            { "time", "Month" },
            { "tickets", lastMonthTicketsSold }
        },
        new Dictionary<string, object>
        {
            { "time", "All time" },
            { "tickets", totalTicketsSold }
        }
    };
        }


        public async Task<List<Dictionary<string, object>>> GetMostSoldEvents()
        {
            var mostSoldEvents = await _context.NarudzbaStavkes
                .GroupBy(ns => ns.TipKarte.DogadjajId)
                .Select(group => new
                {
                    DogadjajId = group.Key,
                    TicketsSold = group.Sum(ns => ns.Kolicina)
                })
                .OrderByDescending(x => x.TicketsSold)
                .Take(3)
                .Join(
                    _context.Dogadjajis,
                    aggregated => aggregated.DogadjajId,
                    dogadjaj => dogadjaj.DogadjajId,
                    (aggregated, dogadjaj) => new
                    {
                        DogadjajName = dogadjaj.Naziv,
                        TicketsSold = aggregated.TicketsSold
                    })
                .ToListAsync();

            return mostSoldEvents
                .Select(e => new Dictionary<string, object>
                {
            { "dogadjaj", e.DogadjajName },
            { "tickets", e.TicketsSold }
                })
                .ToList();
        }


    }
}
