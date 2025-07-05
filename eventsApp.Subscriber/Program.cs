using EasyNetQ;
using eventsApp.Model.Messages;
using System.Text;
using MailingService;

public class EmailService
{
    private static readonly Queue<Func<Task>> eventInFollowingCategoryQueue = new Queue<Func<Task>>();
    private static bool eventInFollowingCategoryIsProcessing = false;

    public static async Task Main(string[] args)
    {
        var hostName = Environment.GetEnvironmentVariable("RABBITMQ_CONNECTIONSTRING") ?? "host=localhost";

        using (var bus = RabbitHutch.CreateBus(hostName))
        {
            var cts = new CancellationTokenSource();
            Console.CancelKeyPress += (sender, e) =>
            {
                e.Cancel = true;
                cts.Cancel();
            };

            Console.WriteLine("Subscribing to RabbitMQ messages...");

            await bus.PubSub.SubscribeAsync<UserRegisteredModel>("user_registered", async msg =>
            {
                Console.WriteLine("New user registered.");
                try
                {
                    await EmailServiceImpl.SendUserRegisteredEmail(msg);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error processing user_registered message: {ex.Message}");
                }
            });

            await bus.PubSub.SubscribeAsync<OrderModel>("order", async msg =>
            {
                Console.WriteLine("New order was made.");
                try
                {
                    await EmailServiceImpl.SendOrderEmail(msg);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error processing order message: {ex.Message}");
                }
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
                    _ = Task.Run(ProcessEventQueue);
                }
            });

            Console.WriteLine("Listening for messages. Press Ctrl+C to quit.");
            try
            {
                await Task.Delay(Timeout.Infinite, cts.Token);
            }
            catch (TaskCanceledException)
            {
                Console.WriteLine("Shutting down gracefully...");
            }
        }
    }

    private static async Task ProcessEventQueue()
    {
        while (eventInFollowingCategoryQueue.Count > 0)
        {
            var nextMessage = eventInFollowingCategoryQueue.Dequeue();
            await nextMessage();
        }
        eventInFollowingCategoryIsProcessing = false;
    }
}