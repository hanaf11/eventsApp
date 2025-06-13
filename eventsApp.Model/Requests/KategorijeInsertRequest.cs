using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class KategorijeInsertRequest
    {
        [Required]
        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public byte[] Slika { get; set; } = null!;
    }
}
