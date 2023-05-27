using AutoMapper;
using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class CancelledEventState : BaseState
    {
        public CancelledEventState(IServiceProvider serviceProvider, EventsDbContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }
    }
}
