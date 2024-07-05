using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Linq.Dynamic;

namespace eventsApp.Services
{
   public abstract class BaseService<T, TDetails, TDb, TSearch>:IService<T, TDetails, TSearch> where T:class where TDb : class where TDetails:class where TSearch: BaseSearchObject
    {
        protected EventsDbContext _context;
        protected IMapper _mapper { get; set; }

        public BaseService(EventsDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        
        public virtual async Task<PagedResult<T>> Get(TSearch? search=null)
        {
            var query = _context.Set<TDb>().AsQueryable();

            PagedResult<T> result = new PagedResult<T>();

            query = AddFilter(query, search);
             query=AddInclude(query, search);

            result.Count = await query.CountAsync();

            if (!string.IsNullOrWhiteSpace(search?.OrderBy))
            {
               // query = query.OrderBy(search.OrderBy);
            }

            if (search?.Page.HasValue==true && search?.PageSize.HasValue == true)
            {
                query = query.Skip(search.Page.Value * search.PageSize.Value).Take(search.PageSize.Value);
            }
            var list = await query.ToListAsync();

            result.Result = _mapper.Map<List<T>>(list);

            return result;
        }

        public virtual async Task<TDetails> GetById(int id)
        {
            //var entity = await _context.Set<TDb>().FindAsync(id);
            var entity = await FindEntity(id);

            if (entity != null)
            {
                return _mapper.Map<TDetails>(entity);
            }
            else return null;
        }

        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public virtual async Task<TDb> FindEntity(int id)
        {
            return await _context.Set<TDb>().FindAsync(id);
        }
    }
}
