using System;
using System.Collections.Generic;

namespace eventsApp.Model.Messages
{
    public class OrderModel
    {
        public Dogadjaji Dogadjaj { get; set; }
        public Narudzbe Narudzba { get; set; }
        public List<Karta> Karte { get; set; }
        public List<ValidTipKarte> ListaKarata { get; set; }

        public OrderModel(Dogadjaji dogadjaj, Narudzbe narudzba, List<Karta> karte, List<ValidTipKarte> listaKarata)
        {
            Dogadjaj = dogadjaj;
            Narudzba = narudzba;
            Karte = karte;
            ListaKarata = listaKarata;
        }
    }
}
