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
        public ActiveEventState(ILogger<ActiveEventState> logger, IServiceProvider serviceProvider, EventsDbContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
            _logger = logger;
        }
    }
}

