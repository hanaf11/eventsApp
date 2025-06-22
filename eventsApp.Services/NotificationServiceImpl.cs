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
        private readonly ILogger<NotificationServiceImpl> _logger;
        private readonly IMapper _mapper;
        private readonly EventsDbContext _dbContext;
        private readonly IRabbitMqPublisher _rabbitMqPublisher;
        public NotificationServiceImpl(EventsDbContext context, IMapper mapper, ILogger<NotificationServiceImpl> logger, IRabbitMqPublisher rabbitMq) 
        {
            _logger = logger;
            _mapper = mapper;   
            _dbContext = context;
            _rabbitMqPublisher = rabbitMq;
        }

        public void SendEventActivatedMail(Model.Dogadjaji dogadjaj)
        {
            List<String> subscribersEmails = _dbContext.Pracenjes.Where(p => p.KategorijaId == dogadjaj.KategorijaId).Select(p => p.Korisnik.Email).ToList();

            foreach (var email in subscribersEmails)
            {
                NotifySubscribers message = new NotifySubscribers(dogadjaj, email);
                _rabbitMqPublisher.Publish(message);
            }
            

        }

        public void SendRegisteredMail(string email, string ime)
        {
            UserRegisteredModel message = new UserRegisteredModel(email,ime);
            _rabbitMqPublisher.Publish(message);
        }

        public void SendOrderMail(Model.Dogadjaji dogadjaj, Model.Narudzbe narudzba, List<ValidTipKarte> listaKarata, List<Model.Karta> karte)
        {
            OrderModel message = new OrderModel(dogadjaj, narudzba, karte, listaKarata);
            _rabbitMqPublisher.Publish(message);
        }

        public void SendTicketsRequest(KarteDobavljacRequest request)
        {
            _rabbitMqPublisher.Publish(request);
        }
    }
}
