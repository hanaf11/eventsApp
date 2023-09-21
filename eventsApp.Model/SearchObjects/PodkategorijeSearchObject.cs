using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.SearchObjects
{
    public class PodkategorijeSearchObject:BaseSearchObject
    {
        public string? Naziv { get; set; }
        public int? KategorijaId { get; set; }
    }
}
