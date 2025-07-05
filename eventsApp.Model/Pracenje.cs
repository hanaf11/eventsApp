using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Pracenje
    {
        public int PracenjeId { get; set; }

        public int KorisnikId { get; set; }

        public int KategorijaId { get; set; }

        public DateTime Vrijeme { get; set; }

        public Kategorije? Kategorija { get; set; }
    }
}
