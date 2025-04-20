using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.SearchObjects
{
    public class NarudzbaSearchObject : BaseSearchObject
    {
        public string? Username { get; set; }
        public string? BrojNarudzbe { get; set; }
        public DateTime? Datum { get; set; }

    }
}
