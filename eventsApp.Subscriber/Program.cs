// See https://aka.ms/new-console-template for more information
using EasyNetQ;
using eventsApp.Model;
using eventsApp.Model.Messages;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using System.Net.Mail;
using System.Net;
using MailingService;

public class EmailService
{
    private static readonly Queue<Func<Task>> eventInFollowingCategoryQueue = new Queue<Func<Task>>();
    private static bool eventInFollowingCategoryIsProcessing = false;


    public static async Task Main(string[] args)
    {

        using (var bus = RabbitHutch.CreateBus("host=localhost"))
        {
            // bus.PubSub.Subscribe<DogadjajActivated>("seminarski", HandleTextMessage;
            await bus.PubSub.SubscribeAsync<UserRegisteredModel>("user_registered", async msg =>
            {
                Console.WriteLine($"New user registered");
                await EmailServiceImpl.SendUserRegisteredEmail(msg);
            });

            await bus.PubSub.SubscribeAsync<OrderModel>("order", async msg =>
            {
                Console.WriteLine($"New order was made");
                await EmailServiceImpl.SendOrderEmail(msg);
            });



            await bus.PubSub.SubscribeAsync<NotifySubscribers>("event_activated", async msg =>
            {
                Console.WriteLine($"Event activated: {msg.Dogadjaj.Naziv} from category: {msg.Dogadjaj.Kategorija.Naziv}");

                eventInFollowingCategoryQueue.Enqueue(async () =>
                {
                    try
                    {
                        Console.WriteLine("Waiting for email to send...");
                        await EmailServiceImpl.SendEventInFollowingCategoryEmail(msg);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"Error sending email: {ex.Message}");
                    }
                });

                if (!eventInFollowingCategoryIsProcessing)
                {
                    eventInFollowingCategoryIsProcessing = true;
                    while (eventInFollowingCategoryQueue.Count > 0)
                    {
                        var nextMessage = eventInFollowingCategoryQueue.Dequeue();
                        await nextMessage();
                    }
                    eventInFollowingCategoryIsProcessing = false;
                }
            });


            Console.WriteLine("Listening for messages. Hit <return> to quit.");
            Console.ReadLine();
        }
    }
}


