using AutoMapper;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;

using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class GalerijaServiceImpl : BaseService<Model.Slike, Model.Slike, Database.Slike, GalerijaSearchObject>, IGalerijaService
    {

        public GalerijaServiceImpl(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Slike> AddFilter(IQueryable<Database.Slike> query, GalerijaSearchObject? search = null)
        {
            if (search?.DogadjajId!=null)
            {
                query = query.Where(x => x.DogadjajId==search.DogadjajId);
            }
        
            return base.AddFilter(query, search);
        }


        public async Task<Model.Slike> Delete(int id)
        {
            var set = _context.Set<Database.Slike>();

            var entity = await set.FindAsync(id);

            if (entity == null)
            {
                throw new Exception($"Entity with ID {id} not found.");
            }

            set.Remove(entity);

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Slike>(entity);
        }
    }
}
