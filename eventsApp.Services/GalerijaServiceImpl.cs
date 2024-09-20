using AutoMapper;
using eventsApp.Model.Requests;
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


        public async Task InsertGallery(int dogadjajId, List<byte[]> request)
        {
            var set = _context.Set<Database.Slike>();

            foreach (var slikaByte in request)
            {
                /* slikaModel.DogadjajId = dogadjajId;
                 var slikaEntity = _mapper.Map<Database.Slike>(slikaModel);*/


                set.Add(CreateSlika(new SlikeInsertRequest(){Slika= slikaByte, DogadjajId=dogadjajId}));
            }
            await _context.SaveChangesAsync();
        }

        public Database.Slike CreateSlika(SlikeInsertRequest slikaModel)
        {
            return _mapper.Map<Database.Slike>(slikaModel);
        }


        public async Task UpdateGallery(int dogadjajId, List<SlikeInsertRequest> request)
        {
            var set = _context.Set<Database.Slike>();

            List<Database.Slike> galerija = await set.Where(x => x.DogadjajId == dogadjajId).ToListAsync();

            if (galerija == null)
            {
                List<byte[]> slikeByteList=new List<byte[]>();
                foreach (var slika in request)
                {
                    slikeByteList.Add(slika.Slika);
                }
                await InsertGallery(dogadjajId, slikeByteList);
            }
            else
            {
                foreach (var slikaModel in request)
                {
                    if (slikaModel.SlikaId == null)
                    {
                        set.Add(CreateSlika(new SlikeInsertRequest() { Slika=slikaModel.Slika, DogadjajId=dogadjajId}));
                    }

                }
                await _context.SaveChangesAsync();
            }

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
