using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Messages
{
    public class OrderModel
    {
        public Dogadjaji Dogadjaj;
        public Narudzbe Narudzba;
        public List<Karta> Karte;
        public List<ValidTipKarte> ListaKarata;

        public OrderModel(Dogadjaji dogadjaj, Narudzbe narudzba, List<Karta> karte, List<ValidTipKarte> listaKarata)
        {
            Dogadjaj = dogadjaj;
            Narudzba = narudzba;
            Karte = karte;
            ListaKarata = listaKarata;
        }
    }
}
