using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Podkategorije
    {
        public int PodkategorijaId { get; set; }

        public string Naziv { get; set; } = null!;

        public int KategorijaId { get; set; }

    }
}
