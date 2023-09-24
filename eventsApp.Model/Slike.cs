using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Slike
    {
        public int SlikaId { get; set; }

        public byte[] Slika { get; set; } = null!;

    }
}
