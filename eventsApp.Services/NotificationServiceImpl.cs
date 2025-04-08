using AutoMapper;
using EasyNetQ;
using eventsApp.Model;
using eventsApp.Model.Messages;
using eventsApp.Services.Database;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class NotificationServiceImpl:INotificationService
    {
        ILogger<NotificationServiceImpl> _logger;
        IMapper _mapper;
        EventsDbContext _dbContext;
        public NotificationServiceImpl(EventsDbContext context, IMapper mapper, ILogger<NotificationServiceImpl> logger) 
        {
            _logger = logger;
            _mapper = mapper;   
            _dbContext = context;

        }

        public void SendEventActivatedMail(Model.Dogadjaji dogadjaj)
        {
            List<String> subscribersEmails = _dbContext.Pracenjes.Where(p => p.KategorijaId == dogadjaj.KategorijaId).Select(p => p.Korisnik.Email).ToList();

            using var bus = RabbitHutch.CreateBus("host=localhost");

            foreach (var email in subscribersEmails)
            {
                NotifySubscribers message = new NotifySubscribers(dogadjaj, email);
                bus.PubSub.Publish(message);
            }
            

        }

        public void SendRegisteredMail(string email, string ime)
        {
            using var bus = RabbitHutch.CreateBus("host=localhost");

            UserRegisteredModel message = new UserRegisteredModel(email,ime);
            bus.PubSub.Publish(message);
        }

        public void SendOrderMail(Model.Dogadjaji dogadjaj, Model.Narudzbe narudzba, List<ValidTipKarte> listaKarata, List<Model.Karta> karte)
        {
            using var bus = RabbitHutch.CreateBus("host=localhost");

            OrderModel message = new OrderModel(dogadjaj, narudzba, karte, listaKarata);
            bus.PubSub.Publish(message);
        }
    }
}
