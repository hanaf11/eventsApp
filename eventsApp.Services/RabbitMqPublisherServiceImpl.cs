using EasyNetQ;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class RabbitMqPublisherService : IRabbitMqPublisher
    {
        private readonly IBus _bus;

        public RabbitMqPublisherService(string hostName = "host=localhost")
        {
            _bus = RabbitHutch.CreateBus(hostName);
        }

        public void Publish<T>(T message) where T : class
        {
            _bus.PubSub.Publish(message);
        }

        public void Dispose()
        {
            _bus.Dispose();
        }
    }

}
