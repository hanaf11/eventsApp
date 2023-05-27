using AutoMapper;
using eventsApp.Services.Database;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class ActiveEventState : BaseState
    {
        protected ILogger<ActiveEventState> _logger;
        public ActiveEventState(ILogger<ActiveEventState> logger,IServiceProvider serviceProvider,EventsDbContext context, IMapper mapper) : base(serviceProvider,context, mapper)
        {
            _logger = logger;
        }

        public override async Task<Model.Dogadjaji> Cancel(int id)
        {
            _logger.LogInformation($"Cancel događaja {id}");

            var set = _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            entity.Status = "Cancelled";

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Dogadjaji>(entity);
        }

        public override async Task<List<string>> AllowedActions()
        {
            var list = await base.AllowedActions();
            list.Add("Cancel");

            return list;
        }
    }
}
