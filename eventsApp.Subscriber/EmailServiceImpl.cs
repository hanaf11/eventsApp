using eventsApp.Model;
using eventsApp.Model.Messages;
using System;
using System.Net;
using System.Net.Mail;
using System.Text;

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
            Timeout = 30000
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



        public static async Task SendOrderEmail(OrderModel order)
        {
            try
            {
                string emailBody = $@"
Pozdrav {order.Narudzba.Ime},  

Hvala Vam što ste izvršili kupovinu putem EventsApp-a! 🎟️  
Vaša narudžba je uspješno zaprimljena.

Detalji Vaše narudžbe:  
- **Broj narudžbe:** {order.Narudzba.BrojNarudzbe}  
- **Datum narudžbe:** {order.Narudzba.Datum}  

**Pregled narudžbe:**  
- Naziv događaja: {order.Dogadjaj.Naziv}  
- Datum i vrijeme: {order.Dogadjaj.DatumOd} - {order.Dogadjaj.DatumDo}
- Lokacija: {order.Dogadjaj.Lokacija}

-Karte:";

        foreach(ValidTipKarte tipKarte in order.ListaKarata)
                {
                    emailBody += $@"
{tipKarte.Naziv} x{tipKarte.Kolicina} - {tipKarte.Cijena}KM";
                }



                emailBody += $@"
Ukupno: {order.Narudzba.Cijena}KM

**Adresa za isporuku:**  
{order.Narudzba.Ime} {order.Narudzba.Prezime}  
{order.Narudzba.Adresa}
{order.Narudzba.PostanskiBroj} {order.Narudzba.Grad}
{order.Narudzba.Drzava}
{order.Narudzba.Telefon}


";

                if (order.Narudzba.Tip == "Poštom")
                {
                    emailBody += $@"

Vaše ulaznice će biti poslane na navedenu adresu putem pošte.";
                } else if (order.Narudzba.Tip == "E-karta")
                {
                    emailBody += $@"

Ulaznice možete preuzeti u prilogu mail-a i pokazati na ulazu.";
                }



emailBody += $@"
Ako imate bilo kakvih pitanja ili trebate dodatne informacije, slobodno nas kontaktirajte – ovdje smo da Vam pomognemo!  

Još jednom, hvala što koristite EventsApp i uživajte na Vašem događaju!  

Srdačno,  
Vaš Tim EventsApp  
";



                var message = new MailMessage(
                    from: _mail,
                    to: order.Narudzba.Email,
                    subject: $"Potvrda narudžbe na EventsApp",
                    body: emailBody
                );
                if (order.Narudzba.Tip == "E-karta")
                {
                     string documentName = GenerateETickets(order.Dogadjaj, order.Karte);
                    // byte[] ticketBytes = Encoding.Unicode.GetBytes(fileContent);

                    /*   using (var memoryStream = new MemoryStream(ticketBytes))
                       {
                           memoryStream.Position = 0;
                           string fileName = $"{order.Dogadjaj.Naziv.Replace(" ","_")}_eTicket.txt";

                           // Attachment attachment = new Attachment(memoryStream, fileName, "text/plain; charset=utf-16");
                           // message.Attachments.Add(attachment);
                           if (memoryStream.CanRead)
                           {
                               Attachment attachment = new Attachment(memoryStream, fileName, "text/plain; charset=utf-16");
                               message.Attachments.Add(attachment);
                           }
                       }*/
                    message.Attachments.Add(new Attachment("C:\\Users\\Hana\\Desktop\\" + documentName));
                }
                
                Console.WriteLine($"From: {_mail}, To:{order.Narudzba.Email}");
                await client.SendMailAsync(message);
                Console.WriteLine("Email sent successfully.");
            }
            catch (SmtpException smtpEx)
            {
                Console.WriteLine($"SMTP Error: {smtpEx.Message}");
                if (smtpEx.InnerException != null)
                {
                    Console.WriteLine($"Inner Exception: {smtpEx.InnerException.Message}");
                }
                Console.WriteLine($"Retrying... Attempt");
                await Task.Delay(3000);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }

        private static string GenerateETickets(Dogadjaji dogadjaj, List<Karta> karte)
        {
            string documentName = dogadjaj.Naziv.Replace(" ","_") + "_eTicket.txt";
            string fileContent="";

            foreach(Karta karta in karte)
            {
                fileContent += $@"

*******************************
EventsApp - E-Karta

Naziv događaja: {dogadjaj.Naziv}
Datum i vrijeme: {dogadjaj.DatumOd}
Lokacija:{dogadjaj.Lokacija}

Detalji ulaznice:
- Broj ulaznice: {karta.Sifra}
- Sektor: {karta.TipKarte.Naziv}";
                if (karta.Sjediste != null)
                {
                    fileContent += $@"
- Sjedište: {karta.Sjediste}
*******************************";
                }

            }

            File.WriteAllText("C:\\Users\\Hana\\Desktop\\"+documentName, fileContent);
            return fileContent;
        }

    }
}

