using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Narudzbe
    {
        public string BrojNarudzbe { get; set; } = null!;

        public int KorisnikId { get; set; }

        public DateTime Datum { get; set; }

        public decimal IznosSaPdv { get; set; }
    }
}
