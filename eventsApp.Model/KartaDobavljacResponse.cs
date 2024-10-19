using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class KartaDobavljacResponse
    {
        public int RowNum { get; set; }

        public string TipKarte { get; set; }

        public string Sifra { get; set; }

        public string? Sjediste { get; set; }
    }
}
