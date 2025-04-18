using eventsApp.Model;
using eventsApp.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IService<T, TDetails, TSearch> where TSearch:BaseSearchObject where TDetails : class
    {
        Task<PagedResult<T>> Get(TSearch search=null);
        Task<TDetails> GetById(int? korisnikId,int id);
   
    }
}
