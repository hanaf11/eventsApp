using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class KorisniciReportResponse
    {
        public List<Dictionary<string, object>> NumberOfRegistered { get; set; }
        public List<Dictionary<string, object>> MostOrdersUsers { get; set; }
        public List<Dictionary<string, object>> MostActiveUsers { get; set; }
        public List<Dictionary<string, object>> MostSubscribedCategories { get; set; }
    }
}
