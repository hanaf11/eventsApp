using AutoMapper;
using EasyNetQ;
using eventsApp.Model.Messages;
using eventsApp.Model.Requests;
using eventsApp.Services.Database;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class VerifiedEventState : BaseState
    {
        protected readonly INotificationService _notificationService;
        public VerifiedEventState(IServiceProvider serviceProvider, EventsDbContext context, IMapper mapper, INotificationService notificationService) : base(serviceProvider, context, mapper)
        {
            _notificationService = notificationService;
        }

        public override async Task<Model.Dogadjaji> SendRequestForTickets(int id, List<KarteRequest> request)
        {
            var set = _context.Set<Database.Dogadjaji>();
            var entity = await set.FindAsync(id);

             KarteDobavljacRequest message = new KarteDobavljacRequest { Dogadjaj = entity.Naziv, Datum = entity.DatumOd, Lokacija = entity.Lokacija, KarteZahtjev = request };
            _notificationService.SendTicketsRequest(message);

            entity.Status = "ON_HOLD";
            entity.Created = DateTime.Now;
           await  _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<Model.Dogadjaji>(entity);
            return mappedEntity;
        }


        public override List<string> AllowedActions(Database.Dogadjaji entity)
        {
            return new List<string>() { nameof(SendRequestForTickets) };
        }
    }
}
