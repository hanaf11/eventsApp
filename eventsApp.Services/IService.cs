using eventsApp.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IService<T, TDetails, TSearch> where TSearch:class where TDetails : class
    {
        Task<PagedResult<T>> Get(TSearch search=null);
        Task<TDetails> GetById(int id);
   
    }
}
