using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
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
                await InsertLinkedEntity(entity, request);
            }

            return _mapper.Map<Dogadjaji>(entity);
        }

        public  async Task InsertLinkedEntity(Database.Dogadjaji entity, DogadjajiInsertRequest insert)
        {
            var set = _context.Set<Database.Slike>();

            foreach (var slikaModel in insert.Galerija)
            {
                slikaModel.DogadjajId = entity.DogadjajId;
                var slikaEntity = _mapper.Map<Database.Slike>(slikaModel);
         
                set.Add(slikaEntity);
            }
            await _context.SaveChangesAsync();
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
