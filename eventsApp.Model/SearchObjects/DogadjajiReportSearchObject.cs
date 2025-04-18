using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.SearchObjects
{
    public class DogadjajiReportSearchObject
    {
        public bool? EventsByStatus { get; set; }
        public bool? EventsByCategory { get; set; }
        public bool? TopSellingEvents { get; set; }
        public bool? MostViewedEvents { get; set; }
        public bool? MostSavedEvents { get; set; }
    }
}
