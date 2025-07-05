using AutoMapper;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class HistorijaPregledaServiceImpl: IHistorijaPregledaService
    {
        protected EventsDbContext _context;
        protected IMapper _mapper;
        public HistorijaPregledaServiceImpl(EventsDbContext context, IMapper mapper)
        {
            _context = context; 
             _mapper = mapper;
        }

        public async Task Create(int? korisnikId, int? dogadjajId)
        {
            if (!korisnikId.HasValue || !dogadjajId.HasValue)
            {
                return; 
            }

            var korisnikExists = await _context.Korisnicis.AnyAsync(k => k.KorisnikId == korisnikId.Value);
            var dogadjajExists = await _context.Dogadjajis.AnyAsync(d => d.DogadjajId == dogadjajId.Value);

            if (!korisnikExists || !dogadjajExists)
            {
                return;
            }

            var historijaPregledaEntity = new HistorijaPregledum
            {
                KorisnikId = korisnikId.Value,
                DogadjajId = dogadjajId.Value,
                Vrijeme = DateTime.Now 
            };

            _context.HistorijaPregleda.Add(historijaPregledaEntity);
            await _context.SaveChangesAsync();
        }

        public async Task<List<Model.Dogadjaji>> GetByKorisnikId(int korisnikId)
        {
            List<Database.Dogadjaji> dogadjaji =await _context.Set<HistorijaPregledum>()
                .Where(hp => hp.KorisnikId == korisnikId)
                .Include(hp => hp.Dogadjaj).ThenInclude(d=>d.Kategorija)
                .OrderByDescending(hp=>hp.Vrijeme)
                .Select(hp => hp.Dogadjaj)
                .ToListAsync();

            var result = _mapper.Map<List<Model.Dogadjaji>>(dogadjaji);

            return result;
        }

        public async Task<List<Dictionary<string, object>>> GetMostViewedEvents()
        {
            var topViewedEvents = await _context.HistorijaPregleda
                .GroupBy(h => h.DogadjajId)
                .Select(group => new
                {
                    DogadjajId = group.Key,
                    ViewCount = group.Count()
                })
                .OrderByDescending(x => x.ViewCount)
                .Take(3)
                .Join(
                    _context.Dogadjajis,
                    h => h.DogadjajId,
                    d => d.DogadjajId,
                    (h, d) => new
                    {
                        d.Naziv,
                        h.ViewCount
                    })
                .ToListAsync();

            return topViewedEvents.Select(e => new Dictionary<string, object>
            {
              { "dogadjaj", e.Naziv },
              { "views", e.ViewCount }
           }).ToList();
        }


    }
}
