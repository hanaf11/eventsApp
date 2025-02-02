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

        public override async Task<Model.Dogadjaji> Activate(int id)
        {
            var set =  _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            entity.Status = "ACTIVE";
            entity.Created = DateTime.Now;

            await _context.SaveChangesAsync();

            /*var factory = new ConnectionFactory { HostName = "localhost" };
            using var connection = factory.CreateConnection();
            using var channel= connection.CreateModel();

            channel.QueueDeclare(queue:"category_subscription",
                                 durable:false,
                                 exclusive:false,
                                 autoDelete:false,
                                 arguments:null);
            const string message = "aa";
            var body = Encoding.UTF8.GetBytes(message);

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "category_subscription",
                                 basicProperties: null,
                                 body: body);*/

            var mappedEntity=_mapper.Map<Model.Dogadjaji>(entity);

            /* using var bus = RabbitHutch.CreateBus("host=localhost");
             DogadjajActivated message = new DogadjajActivated { Dogadjaj = mappedEntity };
             bus.PubSub.Publish(message);*/
            _notificationService.SendEventActivatedMail(mappedEntity);

            return mappedEntity;
        }

        public override async Task<Model.Dogadjaji> SendRequestForTickets(int id, List<KarteRequest> request)
        {
            var set = _context.Set<Database.Dogadjaji>();
            var entity = await set.FindAsync(id);

            using var bus = RabbitHutch.CreateBus("host=localhost");
            KarteDobavljacRequest message = new KarteDobavljacRequest { Dogadjaj = entity.Naziv, Datum = entity.DatumOd, Lokacija = entity.Lokacija, KarteZahtjev = request };
            bus.PubSub.Publish(message);

            entity.Status = "ON_HOLD";
            entity.Created = DateTime.Now;
           await  _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<Model.Dogadjaji>(entity);
            return mappedEntity;
        }


        public override List<string> AllowedActions(Database.Dogadjaji entity)
        {
            // list.Add("GetTickets");
            return new List<string>() { nameof(Activate) };
        }
    }
}
