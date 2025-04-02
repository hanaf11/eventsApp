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
        public Task<Database.TipKarte> FindTip(string naziv, int dogadjajId);

        public Task UpdateStanje(Dictionary<string, int> stanje, int dogadjajId);
        public Task<bool> DeleteByDogadjaj(int dogadjajId);
        public Task<Database.TipKarte> TicketsAvailable(int tipKarteId, int kolicina);
    }
}
