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
        // private static async Task SendEmail()
        {
            //1 smtp client
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

            //svaki put novi smtp client
            /*     try
            {
                var message = new MailMessage(
                    from: _mail,
                    to: "hannabern1@gmail.com",
                    subject: $"Novi događaj u kategoriji {notification.Dogadjaj.Kategorija.Naziv}",
                    body: $"Aktiviran je dogadjaj {notification.Dogadjaj.Naziv}"
                //  body: "Aktiviran je dogadjaj Kulin ban"
                );
                Console.WriteLine($"From: {_mail}, To:hanna");
                await client.SendMailAsync(message);
                Console.WriteLine("Email sent successfully.");
            }*/
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

