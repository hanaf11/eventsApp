using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class TipKarte
    {
        public int TipKarteId { get; set; }

        public string Naziv { get; set; } = null!;

        public decimal Cijena { get; set; }

        public int Stanje { get; set; }

        public bool NumerisanjeSjedista { get; set; }

        public Dogadjaji? Dogadjaj { get; set; }
    }
}
