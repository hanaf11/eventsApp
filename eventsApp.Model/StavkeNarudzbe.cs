using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class StavkeNarudzbe
    {
        public int NarudzbaStavkaId { get; set; }

        public int NarudzbaId { get; set; }

        public int TipKarteId { get; set; }

        public int Kolicina { get; set; }

        public decimal Cijena { get; set; }

        public string? TipKarte { get; set; }

        public string? Dogadjaj { get; set; }
    }
}
