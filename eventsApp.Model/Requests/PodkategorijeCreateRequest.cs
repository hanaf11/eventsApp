using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class PodkategorijeCreateRequest
    {
        [Required]
        public string Naziv { get; set; } = null!;

        [Required]
        public int KategorijaId { get; set; }
    }
}
