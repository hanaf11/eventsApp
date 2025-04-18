using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class NarudzbeReportResponse
    {
        public List<Dictionary<string, object>> NumOfOrders { get; set; }
        public List<Dictionary<string, object>> Revenue { get; set; }
        public List<Dictionary<string, object>> NumOfSoldTickets { get; set; }
        public List<Dictionary<string, object>> MostSoldEvents { get; set; }
    }
}
