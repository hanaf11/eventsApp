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

    public static async Task Main(string[] args)
    {
        using (var bus = RabbitHutch.CreateBus("host=localhost"))
        {
            // bus.PubSub.Subscribe<DogadjajActivated>("seminarski", HandleTextMessage;
            await bus.PubSub.SubscribeAsync<KarteDobavljacRequest>("dobavljac", HandleKarteDobavljacRequest);

            Console.WriteLine("Listening for messages. Hit <return> to quit.");
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
        Console.WriteLine("\nDa li možete potvrditi slanje traženih ulaznica? (Y/N)");
        string answer = Console.ReadLine()?.ToUpper();

        if (answer == "Y")
        {
            Console.WriteLine("Ulaznice su potvrđene za slanje.");
            int count = countTickets(msg.KarteZahtjev);
            List<KartaDobavljacResponse> karteList = generateTickets(msg.KarteZahtjev);
            Dictionary<string, int> stanje = handleStanje(msg.KarteZahtjev);
            KarteDobavljacResponseList response = new KarteDobavljacResponseList() { Dogadjaj = msg.Dogadjaj, Datum = msg.Datum, Lokacija = msg.Lokacija, Count = count, KarteList = karteList, Stanje=stanje };
            await SendResponseToEventsAppApi(response);
        }
        else if (answer == "N")
        {
            Console.WriteLine("Slanje ulaznica je odbijeno.");
            KarteDobavljacResponseList response = new KarteDobavljacResponseList() { Dogadjaj = msg.Dogadjaj, Datum = msg.Datum, Lokacija = msg.Lokacija, Count = 0, KarteList=null, Stanje=null };
            await SendResponseToEventsAppApi(response);
        }
        else
        {
            Console.WriteLine("Nevažeći unos. Pokušajte ponovo.");
        }
    }

        private static async Task SendResponseToEventsAppApi(KarteDobavljacResponseList response)
        {
            client.Timeout =TimeSpan.FromSeconds(20);
        try
            {
                string apiUrl = "http://localhost:7294/Dogadjaji/send-tickets";

                string jsonContent = JsonConvert.SerializeObject(response);
            Console.WriteLine(jsonContent);

            var karteList = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                 string username = "admin";
                 string password = "admin";  
                 var byteArray = Encoding.ASCII.GetBytes($"{username}:{password}");
                 client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(byteArray));

            var bodyContent = await karteList.ReadAsStringAsync();

            HttpResponseMessage result = await client.PostAsync(apiUrl, karteList);

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
