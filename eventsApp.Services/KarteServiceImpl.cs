using AutoMapper;
using eventsApp.Model;
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
       public KarteServiceImpl(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public async Task<List<Model.Karta>> NaruciKarte(List<ValidTipKarte> listaKarata)
        {
            List<Database.Karte> lista = new List<Database.Karte>();

            foreach(ValidTipKarte tipKarte in listaKarata)
            {
                var karteByTipKarte = await _context.Set<Database.Karte>()
                 .Where(x => x.TipKarte.TipKarteId == tipKarte.TipKarteId && x.Valid == true)
                 .OrderBy(x => x.Created).Take(tipKarte.Kolicina).ToListAsync();

                karteByTipKarte.ForEach(k => k.Valid = false);

                lista.AddRange(karteByTipKarte);

            }
            await _context.SaveChangesAsync();

             return _mapper.Map<List<Model.Karta>>(lista);

        }
    }
}
