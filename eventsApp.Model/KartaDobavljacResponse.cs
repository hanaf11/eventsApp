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

        public string TipKarte { get; set; } = null!;

        public string Sifra { get; set; } = null!;

        public string? Sjediste { get; set; }
    }
}
