using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.SearchObjects
{
    public class DobavljaciSearchObject:BaseSearchObject
    {
        public string? Naziv { get; set; }
        public string? Adresa { get; set; }
        public string? Dogadjaj { get; set; }
    }
}
