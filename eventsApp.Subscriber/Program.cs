// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using eventsApp.Model;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

Console.WriteLine("Hello, World!");

/*var factory = new ConnectionFactory { HostName = "localhost" };
using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "category_subscription",
                     durable: false,
                     exclusive: false,
                     autoDelete: false,
                     arguments: null);

var consumer = new EventingBasicConsumer(channel);
consumer.Received += (model, ea) =>
{
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    Console.WriteLine($" [x] Received {message}");
};

channel.BasicConsume(queue: "category_subscription",
                     autoAck: true,
                     consumer:consumer) ;*/

using (var bus = RabbitHutch.CreateBus("host=localhost"))
{
    bus.PubSub.Subscribe<eventsApp.Model.Dogadjaji>("test", HandleTextMessage);
    Console.WriteLine("Listening for messages. Hit <return> to quit.");
    Console.ReadLine();
}

void HandleTextMessage(Dogadjaji obj)
{
    Console.WriteLine($"Received: {obj?.DogadjajId}, {obj?.Naziv}");
}