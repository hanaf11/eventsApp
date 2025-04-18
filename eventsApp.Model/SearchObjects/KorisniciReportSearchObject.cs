using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.SearchObjects
{
    public class KorisniciReportSearchObject
    {
        public bool? NumberOfRegistered { get; set; }
        public bool? MostOrdersUsers { get; set; }
        public bool? MostActiveUsers { get; set; }
        public bool? MostSubscribedCategories { get; set; }
    }
}
