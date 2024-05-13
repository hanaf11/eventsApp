using eventsApp.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface ICRUDService<T, TDetails, TSearch, TInsert, TUpdate> : IService<T, TDetails, TSearch> where T:class where TSearch:BaseSearchObject where TDetails:class
    {
        Task<TDetails> Insert(TInsert insert);
        Task<TDetails> Update(int id, TUpdate update);

        Task<TDetails> Delete(int id);
    }
}
