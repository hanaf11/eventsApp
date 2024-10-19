using eventsApp.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Messages
{
    public class KarteDobavljacRequest
    {
        public string Dogadjaj;

        public DateTime Datum;

        public string Lokacija;

        public List<KarteRequest> KarteZahtjev;
    }
}
