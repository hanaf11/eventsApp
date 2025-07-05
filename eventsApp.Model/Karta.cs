using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Karta
    {
        public string Sifra { get; set; } = null!;
        public string? Sjediste { get; set; }
        public TipKarte TipKarte { get; set; } = null!;

    }
}
