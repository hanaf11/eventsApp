using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.SearchObjects
{
    public class KomentarSearchObject:BaseSearchObject
    {
        public int? DogadjajId { get; set; }

        public int? KorisnikId { get; set; }

        public bool? KorisnikIncluded { get; set; }
    }
}
