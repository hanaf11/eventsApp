using eventsApp.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface INotificationService
    {
        public void SendEventActivatedMail(Model.Dogadjaji dogadjaj);

        public void SendRegisteredMail(string mail, string ime);

        public void SendOrderMail(Model.Dogadjaji dogadjaj, Model.Narudzbe narudzba, List<ValidTipKarte> listaKarata, List<Model.Karta> karte);
    }
}
