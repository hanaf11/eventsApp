using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class KarteRequest
    {

        [Required]
        public string Naziv { get; set; }
        [Required]
        public decimal Cijena { get; set; }
        [Required]
        public int Kolicina { get; set; }
        public bool NumerisanjeSjedista { get; set; }
    }
}
