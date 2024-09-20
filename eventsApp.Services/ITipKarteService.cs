using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface ITipKarteService : IService<Model.TipKarte, Model.TipKarte, TipKarteSearchObject>
    {
        public Task InsertTipKarte(int dogadjajId, List<TipKarteInsertRequest> request);
    }
}
