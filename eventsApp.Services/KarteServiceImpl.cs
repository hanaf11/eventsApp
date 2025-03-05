using AutoMapper;
using eventsApp.Model.Messages;
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
    public class KarteServiceImpl : BaseService<Model.Karta, Model.Karta, Database.Karte, KarteSearchObject>, IKarteService
    {
     //   private ITipKarteService _tipKarteService;
       public KarteServiceImpl(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
          //  _tipKarteService = tipKarteService;
        }

        public override IQueryable<Database.Karte> AddFilter(IQueryable<Database.Karte> query, KarteSearchObject? search = null)
        {
          /*  if (search?.DogadjajNaziv != null)
            {
                query = query.Where(x => x.TipKarte.Dogadjaj.Naziv.Contains(search.DogadjajNaziv));
            }*/

            return base.AddFilter(query, search);
        }

        public override IQueryable<Database.Karte> AddInclude(IQueryable<Database.Karte> query, KarteSearchObject? search = null)
        {
           /* if (search?.isTipKarteIncluded==true)
            {
                query = query.Include(k => k.TipKarte);
            }
            if (search?.isDogadjajIncluded == true)
            {
                if (search?.isTipKarteIncluded==true) 
            }*/

  
            return base.AddInclude(query, search);
        }

        public async Task<bool> DeleteByTipKarte(int tipKarteId)
        {
            var ticketsToDelete = _context.Kartes.Where(s => s.TipKarteId == tipKarteId);

            _context.Kartes.RemoveRange(ticketsToDelete);

            await _context.SaveChangesAsync();

            return true;
        }

       /* public async Task CreateKarte(Dogadjaji dogadjaj, KarteDobavljacResponseList karteList)
        {
            var set = _context.Set<Karte>();
            Dictionary<string, int> tipKarteMap = new Dictionary<string, int>();
            foreach (var karta in karteList.KarteList)
            {
                Karte k = new Karte();
                k.Sifra = karta.Sifra;
                k.Sjediste = karta.Sjediste;

                if (tipKarteMap.Count != 0 && tipKarteMap.TryGetValue(karta.TipKarte, out var tipKarteId))
                {
                    k.TipKarteId = tipKarteId;
                    set.Add(k);
                }
                else
                {
                    Database.TipKarte tip = await _tipKarteService.FindTip(karta.TipKarte, dogadjaj.DogadjajId);
                    if (tip != null)
                    {
                        k.TipKarteId = tip.TipKarteId;
                        tipKarteMap.Add(karta.TipKarte, tip.TipKarteId);
                        set.Add(k);

                    }
                }
            }
        }*/
    }
}
