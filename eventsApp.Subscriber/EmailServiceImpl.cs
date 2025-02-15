using eventsApp.Model.Messages;
using System;
using System.Net;
using System.Net.Mail;


namespace MailingService
{
    public class EmailServiceImpl
    {

        private readonly static string _mail = Environment.GetEnvironmentVariable("MAIL") ?? "eventsapprs2@gmail.com";
        private readonly static string _pass = Environment.GetEnvironmentVariable("MAIL_PASS") ?? "sveq qgnq fkwg sufm";
        private readonly static SmtpClient client = new SmtpClient("smtp.gmail.com", 587)
        {
            EnableSsl = true,
            //DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network,
            UseDefaultCredentials = false,
            Credentials = new NetworkCredential(_mail, _pass),
            Timeout = 10000
        };
        private static readonly Queue<Func<Task>> eventInFollowingCategoryQueue = new Queue<Func<Task>>();
        private static bool eventInFollowingCategoryIsProcessing = false;

        public EmailServiceImpl()
        {
        }

        public static async Task SendEventInFollowingCategoryEmail(NotifySubscribers notification)
        {
            try
            {
                string emailBody = $@"
Pozdrav,

uzbuđeni smo što vam možemo javiti da je objavljen novi događaj u kategoriji ""{notification.Dogadjaj.Kategorija.Naziv}""!

📅 **Naziv događaja**: {notification.Dogadjaj.Naziv}  
📍 **Lokacija**: {notification.Dogadjaj.Lokacija}  
🕒 **Datum i vrijeme**: {notification.Dogadjaj.DatumOd}

Evo šta vas očekuje:  
{notification.Dogadjaj.Opis}

Nemojte propustiti ovu sjajnu priliku za nezaboravno iskustvo!  

👉 Provjerite EventsApp aplikaciju da saznate više i osigurate svoje mjesto.

Ostanite s nama za još više uzbudljivih događaja,  
Tim EventsApp
";

                var message = new MailMessage(
                    from: _mail,
                    to: notification.SubscriberEmail,
                    subject: $"🎉 Novi događaj u kategoriji {notification.Dogadjaj.Kategorija.Naziv}!",
                    body: emailBody

                );
                Console.WriteLine($"From: {_mail}, To:{notification.SubscriberEmail}");
                await client.SendMailAsync(message);
                Console.WriteLine("Email sent successfully.");
            }
            catch (SmtpException smtpEx)
            {
                Console.WriteLine($"SMTP Error: {smtpEx.Message}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }


        public static async Task SendUserRegisteredEmail(UserRegisteredModel notification)
        {
            try
            {
                string emailBody = $@"
Pozdrav {notification.Ime},

Uspješno ste se registrovali na EventsApp! 🎉
Oduševljeni smo što ste dio naše zajednice i jedva čekamo da Vam pružimo najbolje iskustvo u praćenju događaja.  

Uz EventsApp možete:  
- Otkriti uzbudljive događaje u vašoj blizini  
- Pratiti kategorije koje vas zanimaju
- Kupiti karte za događaje koji vas zanimaju
- Nikad ne propustiti događaj koji volite  

Ako imate bilo kakvih pitanja ili trebate pomoć, naš tim je uvijek tu za vas.

Dobrodošli i uživajte u korištenju EventsApp-a!  
Vaš Tim EventsApp
";


                var message = new MailMessage(
                    from: _mail,
                    to: notification.Email,
                    subject: $"Uspješna registracija na EventsApp",
                    body: emailBody

                );
                Console.WriteLine($"From: {_mail}, To:{notification.Email}");
                await client.SendMailAsync(message);
                Console.WriteLine("Email sent successfully.");
            }
            catch (SmtpException smtpEx)
            {
                Console.WriteLine($"SMTP Error: {smtpEx.Message}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }

    }
}

