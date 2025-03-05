using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Messages;
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
            throw new UserException("Događaj nije u dozvoljenom statusu");
        }
        public virtual Task<Model.Dogadjaji> Update(int id, DogadjajiUpdateRequest request)
        {
            throw new UserException("Događaj nije u dozvoljenom statusu");
        }

        public virtual Task<Model.Dogadjaji> Verify(int id)
        {
            throw new UserException("Događaj nije u dozvoljenom statusu");
        }

        public virtual Task<Model.Dogadjaji> Activate(int id)
        {
            throw new UserException("Događaj nije u dozvoljenom statusu");
        }

        public virtual Task<Model.Dogadjaji> Hide(int id)
        {
            throw new UserException("Događaj nije u dozvoljenom statusu");
        }

        public virtual Task<Model.Dogadjaji> SendRequestForTickets(int id, List<KarteRequest> request)
        {
            throw new UserException("Događaj nije u dozvoljenom statusu");
        }

        public virtual Task<HttpResponseMessage> LoadTickets(Database.Dogadjaji dogadjaj, KarteDobavljacResponseList karteList)
        {
            throw new UserException("Događaj nije u dozvoljenom statusu");
        }



        public BaseState CreateState(string statusName)
        {
            switch (statusName)
            {
                case "INITIAL": return _serviceProvider.GetService<InitialEventState>();
                case "DRAFT": return _serviceProvider.GetService<DraftEventState>();
                case "VERIFIED": return _serviceProvider.GetService<VerifiedEventState>();
                case "ON_HOLD": return _serviceProvider.GetService<OnHoldEventState>();
                case "ACTIVE": return _serviceProvider.GetService<ActiveEventState>();
                case "HIDDEN": return _serviceProvider.GetService<HiddenEventState>();
                default: throw new UserException("Događaj nije u dozvoljenom statusu");
            }
        }

        public virtual List<string> AllowedActions(Database.Dogadjaji entity)
        {
            //return new List<string>();
            throw new UserException("Not allowed");
        }
    }
}

