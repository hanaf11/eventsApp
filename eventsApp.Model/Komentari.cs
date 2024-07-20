using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Komentari
    {
        public int KomentarId { get; set; }

        public string Komentar { get; set; } = null!;

        public virtual Korisnici Korisnik { get; set; } = null!;
    }
}
