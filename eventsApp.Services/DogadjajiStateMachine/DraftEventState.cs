using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class DraftEventState : BaseState
    {
        protected readonly GalerijaServiceImpl _gallery;
        protected readonly INotificationService _notificationService;
        public DraftEventState(IServiceProvider serviceProvider, EventsDbContext context, IMapper mapper, GalerijaServiceImpl gallery, INotificationService notificationService) : base(serviceProvider, context, mapper)
        {
            _gallery = gallery;
            _notificationService = notificationService;
        }



        public override async Task<Model.Dogadjaji> Update(int id, DogadjajiUpdateRequest request)
            {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            _mapper.Map(request, entity);

            if (entity.Opis == "aa")
            {
                throw new UserException("Opis nije dozvoljen");
            }
            
            if (request.Galerija.Count > 0)
            {
                await _gallery.UpdateGallery(id, request.Galerija);
            }

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Dogadjaji>(entity);
        }

        public override async Task<Model.Dogadjaji> Verify(int id)
        {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = await _context.Dogadjajis
            .Include(d => d.Kategorija) 
              .FirstOrDefaultAsync(d => d.DogadjajId == id);

            if (entity?.DobavljacId == null)
            {
                entity.Status = "ACTIVE";
                Model.Dogadjaji model = _mapper.Map<Model.Dogadjaji>(entity);
                _notificationService.SendEventActivatedMail(model);
            }
            else
            {
                entity.Status = "VERIFIED";
            }
  
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

            var mappedEntity = _mapper.Map<Model.Dogadjaji>(entity);

           /* using var bus = RabbitHutch.CreateBus("host=localhost");
            bus.PubSub.Publish(mappedEntity);*/

            return mappedEntity;
        }

        public async override Task<Model.Dogadjaji> Hide(int id)
        {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            entity.Status = "HIDDEN";
            entity.Created=DateTime.Now;

            await _context.SaveChangesAsync();

            var mappedEntity = _mapper.Map<Model.Dogadjaji>(entity);

            /* using var bus = RabbitHutch.CreateBus("host=localhost");
             bus.PubSub.Publish(mappedEntity);*/

            return mappedEntity;
        }

        public virtual async Task<List<string>> AllowedActions(Database.Dogadjaji entity)
        {
            return new List<string>() { nameof(Update), nameof(Verify), nameof(Hide) };
        }
    }
 }
