using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.SearchObjects
{
    public class DogadjajiSearchObject:BaseSearchObject
    {
        public string? FTS { get; set; }
        public int? Kategorija { get; set; }
        public string? Lokacija { get; set; }
        public DateTime? DatumOd { get; set; }
        public DateTime? DatumDo { get; set; }
        public int? DobavljacId { get; set; }
        public int? Podkategorija { get; set; }
        public bool? KategorijaIncluded { get; set; }
    }
}
