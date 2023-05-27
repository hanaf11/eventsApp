using AutoMapper;
using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class VerifiedEventState : BaseState
    {
        public VerifiedEventState(IServiceProvider serviceProvider, EventsDbContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Model.Dogadjaji> Activate(int id)
        {
            var set =  _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            entity.Status = "Active";

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Dogadjaji>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();
            list.Add("Activate");
            list.Add("GetTickets");

            return list;
        }
    }
}
