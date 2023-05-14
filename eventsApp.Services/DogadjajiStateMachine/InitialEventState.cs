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
        public InitialEventState(Database.EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override async Task<Dogadjaji> Insert(DogadjajiInsertRequest request)
        {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = _mapper.Map<Database.Dogadjaji>(request);

            set.Add(entity);
           // await BeforeInsert(entity, insert);
            await _context.SaveChangesAsync();

            return _mapper.Map<Dogadjaji>(entity);
        }
    }
}
