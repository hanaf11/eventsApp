using eventsApp.Model;
using eventsApp.Model.Messages;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;

namespace eventsApp.Services
{
    public interface IKarteService : IService<Model.Karta, Model.Karta, KarteSearchObject>
    {
        public Task<bool> DeleteByTipKarte(int tipKarteId);

       // public Task CreateKarte(Database.Dogadjaji dogadjaj, KarteDobavljacResponseList karteList); 
    }
}
