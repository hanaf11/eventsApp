using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
   public class BaseState
    {
        protected EventsDbContext _context;
        protected IMapper _mapper { get; set; }

        public IServiceProvider _serviceProvider { get; set; }

        public BaseState(IServiceProvider serviceProvider, EventsDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
            _serviceProvider = serviceProvider;
        }
        public virtual Task<Model.Dogadjaji> Insert(DogadjajiInsertRequest request)
        {
            throw new UserException("Not allowed");
        }
        public virtual Task<Model.Dogadjaji> Update(int id, DogadjajiUpdateRequest request)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Dogadjaji> Activate(int id)
        {
            throw new UserException("Not allowed");
        }

        public virtual Task<Model.Dogadjaji> Cancel(int id)
        {
            throw new UserException("Not allowed");
        }

        public BaseState CreateState(string statusName)
        {
            switch (statusName)
            {
                case "Initial":
                case null:
                    return _serviceProvider.GetService<InitialEventState>();
                    break;
                case "Verified": return _serviceProvider.GetService<VerifiedEventState>();
                    break;
                case "On_Hold": return _serviceProvider.GetService<OnHoldEventState>();
                    break;
                case "Cancelled": return _serviceProvider.GetService<CancelledEventState>();
                    break;
                case "Active": return _serviceProvider.GetService<ActiveEventState>();
                    break;
                default: throw new UserException("Not allowed");
            }
        }

        public virtual async Task<List<string>> AllowedActions()
        {
            return new List<string>();
        }
    }
}

