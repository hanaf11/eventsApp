using AutoMapper;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public abstract class BaseCRUDService<T, TDetails, TDb, TSearch, TInsert, TUpdate> : BaseService<T, TDetails, TDb, TSearch> where TDb:class where T:class where TDetails:class where TSearch:BaseSearchObject
    {
        public BaseCRUDService(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task BeforeInsert(TDb entity, TInsert insert)
        {

        }

        public virtual async Task BeforeUpdate(TDb entity, TUpdate update)
        {

        }

        public virtual async Task ValidateInsert(TInsert insert)
        {

        }

        public virtual async Task ValidateDelete(TDb entity)
        {

        }

        public virtual async Task AfterInsert(TDb entity, TInsert insert)
        {

        }
        public virtual async Task BeforeDelete(TDb entity)
        {
        }

        public virtual async Task<TDetails> Insert(TInsert insert)
        {
            var set = _context.Set<TDb>();

            await ValidateInsert(insert);

            TDb entity = _mapper.Map<TDb>(insert);

            set.Add(entity);

            await BeforeInsert(entity, insert);

            await _context.SaveChangesAsync();

            await AfterInsert(entity, insert);

            return _mapper.Map<TDetails>(entity);
        }

        public virtual async Task<TDetails> Update(int id, TUpdate update)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            _mapper.Map(update, entity);

            await BeforeUpdate(entity, update);

            await _context.SaveChangesAsync();

            return _mapper.Map<TDetails>(entity);
        }

        public virtual async Task<TDetails> Delete(int id)
        {
            var set = _context.Set<TDb>();

            var entity = await set.FindAsync(id);

            if (entity == null)
            {
                throw new Exception($"Entity with ID {id} not found.");
            }

                await ValidateDelete(entity);

                await BeforeDelete(entity);

            // set.Remove(entity);

            if (RequiresSoftDelete(entity))
            {
                ApplySoftDelete(entity);
            }
            else
            {
                set.Remove(entity);
            }

            await _context.SaveChangesAsync();

                return _mapper.Map<TDetails>(entity);

        }

        public virtual bool RequiresSoftDelete(TDb entity)
        {
            return false;
        }

        public virtual void ApplySoftDelete(TDb entity)
        {
            throw new NotImplementedException("Soft delete logic is not implemented for this entity.");
        }
    }
}
