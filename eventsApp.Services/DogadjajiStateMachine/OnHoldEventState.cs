using AutoMapper;
using eventsApp.Model.Messages;
using eventsApp.Services.Database;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class OnHoldEventState : BaseState
    {
        IDogadjajiService _dogadjajiService;
        ITipKarteService _tipKarteService;
        protected ILogger<OnHoldEventState> _logger;

        public OnHoldEventState(IServiceProvider serviceProvider, EventsDbContext context, IMapper mapper, IDogadjajiService dogadjajiService, ITipKarteService tipKarteService, ILogger<OnHoldEventState> logger) : base(serviceProvider, context, mapper)
        {
            _dogadjajiService = dogadjajiService;
            _tipKarteService = tipKarteService;
            _logger = logger;
        }

        public override async Task<Model.Dogadjaji> Activate(int id)
        {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            entity.Status = "ACTIVE";

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

          /*  using var bus = RabbitHutch.CreateBus("host=localhost");
            bus.PubSub.Publish(mappedEntity);*/

            return mappedEntity;
        }


        public override async Task<Model.Dogadjaji> Hide(int id)
        {
            _logger.LogInformation($"Cancel događaja {id}");

            var set = _context.Set<Database.Dogadjaji>();

            var entity = await set.FindAsync(id);

            entity.Status = "HIDDEN";

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Dogadjaji>(entity);
        }

        public virtual async Task<List<string>> AllowedActions(Database.Dogadjaji entity)
        {
            return new List<string>() { nameof(Activate), nameof(Hide), nameof(LoadTickets)};
        }

        public override async Task<HttpResponseMessage> LoadTickets(Database.Dogadjaji dogadjaj, KarteDobavljacResponseList karteList)
        {
            if (karteList.Count == 0)
            {
                await Hide(dogadjaj.DogadjajId);
            }
            else
            {
                var set = _context.Set<Karte>();
                Dictionary<string, int> tipKarteMap = new Dictionary<string, int>();
                foreach (var karta in karteList.KarteList)
                {
                    Karte k = new Karte();
                    k.Sifra = karta.Sifra;
                    k.Sjediste = karta.Sjediste;

                    if (tipKarteMap.Count != 0 && tipKarteMap.TryGetValue(karta.TipKarte, out var tipKarteId))
                    {
                        k.TipKarteId = tipKarteId;
                        set.Add(k);
                    }
                    else
                    {
                        Database.TipKarte tip = _tipKarteService.FindTip(karta.TipKarte, dogadjaj.DogadjajId).Result;
                        if (tip != null)
                        {
                            k.TipKarteId = tip.TipKarteId;
                            tipKarteMap.Add(karta.TipKarte, tip.TipKarteId);
                            set.Add(k);

                        }
                    }
                }

                await _tipKarteService.UpdateStanje(karteList.Stanje, dogadjaj.DogadjajId);
                await Activate(dogadjaj.DogadjajId);
            }

            await _context.SaveChangesAsync();

            return new HttpResponseMessage(HttpStatusCode.OK); 

        }
    }
}
