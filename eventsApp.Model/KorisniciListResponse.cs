using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class KorisniciListResponse
    {
        public int KorisnikId { get; set; }
        public string KorisnickoIme { get; set; } = null!;
        public DateTime Created { get; set; }
    }
}
