using EasyNetQ;
using eventsApp.Model;
using eventsApp.Model.Messages;
using eventsApp.Model.Requests;
using Newtonsoft.Json;
using System.Net.Http.Headers;
using System.Text;

public class Program
{
    private static readonly HttpClient client = new HttpClient(); // HttpClient should be a class-level instance
    private static string RabbitMqConnectionString = string.Empty;
    private static string KarteApiUrl = string.Empty;
    private static string DobavljacUsername = string.Empty;
    private static string DobavljacPassword = string.Empty;

    public static async Task Main(string[] args)
    {
        InitializeEnvironmentVariables();

        using (var bus = RabbitHutch.CreateBus(RabbitMqConnectionString))
        {
            var cts = new CancellationTokenSource();
            Console.CancelKeyPress += (sender, e) =>
            {
                e.Cancel = true;
                cts.Cancel();
            };

            Console.WriteLine("Subscribing to RabbitMQ messages...");

            // bus.PubSub.Subscribe<DogadjajActivated>("seminarski", HandleTextMessage;
            try
            {
                await bus.PubSub.SubscribeAsync<KarteDobavljacRequest>("dobavljac", HandleKarteDobavljacRequest);
            }
            catch (TaskCanceledException ex)
            {
                Console.WriteLine("Task was canceled: " + ex.Message);
            }
            catch (EasyNetQException ex)
            {
                Console.WriteLine("EasyNetQ Error: " + ex.Message);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Unhandled Error: " + ex.Message);
            }


            /* Console.WriteLine("Listening for messages. Hit <return> to quit.");
             //  Console.ReadLine();
             while (true)
             {
                 // Check for user input
                 if (Console.KeyAvailable)
                 {
                     var key = Console.ReadKey(true).Key; // Read the key without displaying it

                     if (key == ConsoleKey.Q)
                     {
                         Console.WriteLine("Exiting...");
                         break; // Exit the loop if 'Q' is pressed
                     }
                 }

                 // Await a short delay to prevent busy waiting
                 await Task.Delay(100); // Adjust delay as needed


             }*/


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


    private static async Task HandleKarteDobavljacRequest(KarteDobavljacRequest msg)
    {
        Console.WriteLine("\nDobili ste novi zahtjev za ulaznice");
        Console.WriteLine($"Događaj: {msg.Dogadjaj}");
        Console.WriteLine($"Datum: {msg.Datum.ToString()}");
        Console.WriteLine($"Lokacija: {msg.Lokacija} \n");

        Console.WriteLine("Tražene ulaznice:");
        foreach (KarteRequest karta in msg.KarteZahtjev)
        {
            Console.WriteLine($"Tip karte: {karta.Naziv}   -   Cijena: {karta.Cijena}   -   Količina: {karta.Kolicina}");
        }

  
            Console.WriteLine("Generisanje ulaznica");
        try
        {
            int count = countTickets(msg.KarteZahtjev);
            List<KartaDobavljacResponse> karteList = generateTickets(msg.KarteZahtjev);
            Dictionary<string, int> stanje = handleStanje(msg.KarteZahtjev);
            KarteDobavljacResponseList response = new KarteDobavljacResponseList() { Dogadjaj = msg.Dogadjaj, Datum = msg.Datum, Lokacija = msg.Lokacija, Count = count, KarteList = karteList, Stanje = stanje };
            await SendResponseToEventsAppApi(response);
        }
        catch (Exception e) { Console.WriteLine($"Exception: {e}"); }
       
    }

        private static async Task SendResponseToEventsAppApi(KarteDobavljacResponseList response)
        {
            client.Timeout =TimeSpan.FromSeconds(120);
        try
            {
               // string apiUrl = "http://localhost:7294/Dogadjaji/send-tickets";

            string jsonContent = JsonConvert.SerializeObject(response);
            Console.WriteLine(jsonContent);

            var karteList = new StringContent(jsonContent, Encoding.UTF8, "application/json");


            var byteArray = Encoding.ASCII.GetBytes($"{DobavljacUsername}:{DobavljacPassword}");
                 client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(byteArray));

            var bodyContent = await karteList.ReadAsStringAsync();

            HttpResponseMessage result = await client.PostAsync(KarteApiUrl, karteList);

            if (result.IsSuccessStatusCode)
                {
                    Console.WriteLine("Uspješno poslano");
                }
                else
                {
                    Console.WriteLine($"Nije moguće poslati odgovor. Status code: {result.StatusCode}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Desila se greška prilikom slanja odgovora: {ex.Message}");
            }
        }

    private static void InitializeEnvironmentVariables()
    {
        RabbitMqConnectionString = Environment.GetEnvironmentVariable("RABBITMQ_CONNECTIONSTRING") ?? "host=localhost";
        KarteApiUrl = Environment.GetEnvironmentVariable("KARTE_API_URL") ?? string.Empty;
        DobavljacUsername = Environment.GetEnvironmentVariable("DOBAVLJAC_USERNAME") ?? string.Empty;
        DobavljacPassword = Environment.GetEnvironmentVariable("DOBAVLJAC_PASSWORD") ?? string.Empty;

        if (string.IsNullOrWhiteSpace(KarteApiUrl))
            throw new InvalidOperationException("The 'KARTE_API_URL' environment variable is missing or empty.");
        if (string.IsNullOrWhiteSpace(DobavljacUsername) || string.IsNullOrWhiteSpace(DobavljacPassword))
            throw new InvalidOperationException("API credentials are missing. Please set 'DOBAVLJAC_USERNAME' and 'DOBAVLJAC_PASSWORD' environment variables.");
    }

    private static int countTickets(List<KarteRequest> karteRequest)
    {
        int count = 0;
        foreach(KarteRequest tip in karteRequest)
        {
            count += tip.Kolicina;
        }
        return count;
    }

    private static List<KartaDobavljacResponse> generateTickets(List<KarteRequest> karteRequest)
    {
        List<KartaDobavljacResponse> karte= new List<KartaDobavljacResponse>();
        foreach(KarteRequest tip in karteRequest)
        {
            for(int i=0; i<tip.Kolicina; i++)
            {
                KartaDobavljacResponse karta = new KartaDobavljacResponse() { RowNum = i + 1, TipKarte = tip.Naziv, Sjediste = tip.NumerisanjeSjedista ? generateSeat() : null, Sifra = generateTicketNum() };
                karte.Add(karta);
            }
            
        }
        return karte;
    }

    private static Dictionary<string, int> handleStanje(List<KarteRequest> karteRequest)
    {
        Dictionary<string, int> stanje = new Dictionary<string, int>();
        foreach (KarteRequest tip in karteRequest)
        {
            stanje.Add(tip.Naziv, tip.Kolicina);
        }
        return stanje;
    }

    private static string generateSeat()
    {
        Random random = new Random();
        char randomRow = (char)random.Next('A', 'Z' + 1);
        int randomSeatNumber = random.Next(1, 50);
        string seatNumber = $"{randomRow}{randomSeatNumber}";
        return seatNumber;
    }

    private static string generateTicketNum()
    {
        return Guid.NewGuid().ToString();
    }

    }
