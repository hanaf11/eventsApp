using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class InitialEventState:BaseState
    {
        public InitialEventState(IServiceProvider serviceProvider,Database.EventsDbContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
        }

        public override async Task<Dogadjaji> Insert(DogadjajiInsertRequest request)
        {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = _mapper.Map<Database.Dogadjaji>(request);
            entity.Status = "Initial";

            set.Add(entity);
           // await BeforeInsert(entity, insert);
            await _context.SaveChangesAsync();
            if (request.Galerija.Count > 0)
            {
                await InsertGallery(entity.DogadjajId, request.Galerija);
            }

            return _mapper.Map<Dogadjaji>(entity);
        }

        public Database.Slike CreateSlika(SlikeInsertRequest slikaModel, int dogadjajId)
        {
            slikaModel.DogadjajId = dogadjajId;
            return  _mapper.Map<Database.Slike>(slikaModel);
        }

        public  async Task InsertGallery(int dogadjajId, List<SlikeInsertRequest> request)
        {
            var set = _context.Set<Database.Slike>();

            foreach (var slikaModel in request)
            {
                /* slikaModel.DogadjajId = dogadjajId;
                 var slikaEntity = _mapper.Map<Database.Slike>(slikaModel);*/
               
         
                set.Add(CreateSlika(slikaModel, dogadjajId));
            }
            await _context.SaveChangesAsync();
        }

        public async Task UpdateGallery(int dogadjajId, List<SlikeInsertRequest> request)
        {
            var set = _context.Set<Database.Slike>();

            List<Database.Slike> galerija = await set.Where(x => x.DogadjajId == dogadjajId).ToListAsync();

            if (galerija == null)
            {
                await InsertGallery(dogadjajId, request);
            }
            else
            {
                foreach (var slikaModel in request)
                {  
                    if (slikaModel.SlikaId == null)
                    {
                        set.Add(CreateSlika(slikaModel, dogadjajId));
                    }
                   
                }
                await _context.SaveChangesAsync();
            }
           
        }

        public override async Task<Dogadjaji> Update(int id, DogadjajiUpdateRequest request)
        {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            if (entity.Opis == "aa")
            {
                throw new UserException("Opis nije dozvoljen");
            }

            if (request.Galerija.Count > 0)
            {
                await UpdateGallery(id, request.Galerija);
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Dogadjaji>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list=await base.AllowedActions();
            list.Add("Verify");
            list.Add("Cancel");

            return list;
        }
    }
}
