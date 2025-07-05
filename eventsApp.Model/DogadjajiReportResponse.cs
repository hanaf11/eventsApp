using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class DogadjajiReportResponse
    {
        public List<Dictionary<string,object>>? EventsByStatus { get; set; }
        public List<Dictionary<string, object>>? EventsByCategory { get; set; }
        public List<Dictionary<string, object>>? MostSavedEvents { get; set; }
        public List<Dictionary<string, object>>? MostViewedEvents { get; set; }
        public List<Dictionary<string, object>>? TopSellingEvents { get; set; }
    }
}
