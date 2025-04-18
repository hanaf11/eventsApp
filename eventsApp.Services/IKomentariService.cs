using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;

namespace eventsApp.Services
{
    public interface IKomentariService : IService<Model.Komentari, Model.Komentari, KomentarSearchObject>
    {
        Task<PagedResult<Model.Komentari>> Post(KomentarInsertObject insert);

        Task<bool> DeleteByDogadjaj(int dogadjajId);

        public Task<List<Dictionary<string, object>>> GetMostActiveUsers();
    }
}
