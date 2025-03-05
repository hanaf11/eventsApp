using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;

namespace eventsApp.Services
{
    public interface IGalerijaService : IService<Model.Slike, Model.Slike, GalerijaSearchObject>
    {
        Task<Model.Slike> Delete(int id);
        Task<bool> DeleteByDogadjaj(int dogadjajId);
    }
}
