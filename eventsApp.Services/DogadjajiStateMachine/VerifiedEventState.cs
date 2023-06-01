using AutoMapper;
using EasyNetQ;
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
        public VerifiedEventState(IServiceProvider serviceProvider, EventsDbContext context, IMapper mapper) : base(serviceProvider, context, mapper)
        {
        }

        public override async Task<Model.Dogadjaji> Activate(int id)
        {
            var set =  _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            entity.Status = "Active";

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

            using var bus = RabbitHutch.CreateBus("host=localhost");
            bus.PubSub.Publish(mappedEntity);

            return mappedEntity;
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
