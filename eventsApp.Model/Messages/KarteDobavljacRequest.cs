using eventsApp.Model.Requests;
using System;
using System.Collections.Generic;

namespace eventsApp.Model.Messages
{
    public class KarteDobavljacRequest
    {
        public string Dogadjaj { get; set; } = null!;

        public DateTime Datum { get; set; }

        public string Lokacija { get; set; } = null!;

        public List<KarteRequest>? KarteZahtjev { get; set; }
    }
}
