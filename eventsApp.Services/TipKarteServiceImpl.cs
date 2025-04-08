using AutoMapper;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using eventsApp.Model;

namespace eventsApp.Services
{
    public class TipKarteServiceImpl : BaseService<Model.TipKarte, Model.TipKarte, Database.TipKarte, TipKarteSearchObject>, ITipKarteService
    {
        private IKarteService _karteService;
        public TipKarteServiceImpl(EventsDbContext context, IMapper mapper, IKarteService karteService) : base(context, mapper)
        {
            _karteService = karteService;
        }

        public async Task InsertTipKarte(int dogadjajId, List<TipKarteInsertRequest> request)
        {
            var set = _context.Set<Database.TipKarte>();

            foreach (var tip in request)
            {
                set.Add(CreateTipKarte(tip, dogadjajId));
            }
            await _context.SaveChangesAsync();
        }

        public Database.TipKarte CreateTipKarte(TipKarteInsertRequest tipKarteReq, int dogadjajId)
        {
            Database.TipKarte tipKarteDb = _mapper.Map<Database.TipKarte>(tipKarteReq);
            tipKarteDb.Stanje = 0;
            tipKarteDb.DogadjajId = dogadjajId;
            return tipKarteDb;
        }

        public async Task<Database.TipKarte> FindTip(string naziv, int dogadjajId)
        {
            var query = _context.Set<Database.TipKarte>();
            return await query.Where(x => x.Naziv == naziv && x.DogadjajId == dogadjajId).FirstOrDefaultAsync();
        }

        public async Task<Model.Dogadjaji> GetDogadjajByTipKarte(int tipKarteId)
        {
            var query = _context.Set<Database.TipKarte>();
            var tipKarte= await query.Where(x => x.TipKarteId == tipKarteId).Include(x=>x.Dogadjaj).FirstOrDefaultAsync();

            if (tipKarte == null) throw new UserException("Ne postoji tip karte s tim ID");

            return _mapper.Map<Model.Dogadjaji>(tipKarte.Dogadjaj);
        }

        public async Task UpdateStanje(Dictionary<string, int> stanjeMap, int dogadjajId)
        {
            foreach (var entry in stanjeMap)
            {
                Database.TipKarte tip = await FindTip(entry.Key, dogadjajId);
                if (tip != null)
                {
                    tip.Stanje += entry.Value;
                }
            }
            await _context.SaveChangesAsync();
        }

        public override IQueryable<Database.TipKarte> AddFilter(IQueryable<Database.TipKarte> query, TipKarteSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
            if (search?.DogadjajId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DogadjajId == search.DogadjajId);
            }
            if (search?.Stanje != null)
            {
                filteredQuery = filteredQuery.Where(x => x.Stanje > search.Stanje);
            }
            return filteredQuery;
        }

        public async Task<bool> DeleteByDogadjaj(int dogadjajId)
        {
            var tipKarteToDelete = await _context.TipKartes.Where(k => k.DogadjajId == dogadjajId).ToListAsync();

            foreach(Database.TipKarte tip in tipKarteToDelete)
            {
                bool hasTickets = await _context.Kartes.Where(k => k.TipKarteId == tip.TipKarteId).AnyAsync();
                if (hasTickets) await _karteService.DeleteByTipKarte(tip.TipKarteId);
            }

            _context.TipKartes.RemoveRange(tipKarteToDelete);

            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<Database.TipKarte> TicketsAvailable(int tipKarteId, int kolicina)
        {
            var tipkarte = await _context.TipKartes
                             .Where(x => x.TipKarteId == tipKarteId)
                             .FirstOrDefaultAsync();

            if (tipkarte == null)
            {
                throw new Model.UserException("Odabrani tip karte ne postoji");
            }
            if (kolicina > tipkarte.Stanje)
            {
                throw new Model.UserException("Odabrani broj karata nije dostupan");
            }
            return tipkarte;
        }

        public async Task UpdateStanjeOduzmi(List<ValidTipKarte> listaKarata)
        {
            foreach (var tipKarte in listaKarata)
            {
                Database.TipKarte? tip = await _context.Set<Database.TipKarte>().Where(x => x.TipKarteId==tipKarte.TipKarteId).FirstOrDefaultAsync();
                if (tip != null)
                {
                    tip.Stanje -= tipKarte.Kolicina;
                }
            }
            await _context.SaveChangesAsync();
        }
    }
}
