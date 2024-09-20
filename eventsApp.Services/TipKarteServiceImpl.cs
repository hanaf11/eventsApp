using AutoMapper;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class TipKarteServiceImpl : BaseService<Model.TipKarte, Model.TipKarte, Database.TipKarte, TipKarteSearchObject>, ITipKarteService
    {
        public TipKarteServiceImpl(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
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
           Database.TipKarte tipKarteDb= _mapper.Map<Database.TipKarte>(tipKarteReq);
            tipKarteDb.Stanje = 0;
            tipKarteDb.DogadjajId=dogadjajId;
            return tipKarteDb;
        }
    }
}
