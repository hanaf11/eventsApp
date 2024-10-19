using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Messages
{
    public class KarteDobavljacResponseList
    {
        public string Dogadjaj { get; set; } = null!;

        public DateTime Datum { get; set; }

        public string Lokacija { get; set; } = null!;

        public int Count { get; set; } 

        public Dictionary<string, int> Stanje { get; set; }

        public List<KartaDobavljacResponse>? KarteList { get; set; }
    }
}
