using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class DobavljaciInsertRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Naziv { get; set; } = null!;
        [Required]
        public string Adresa { get; set; } = null!;
        [Required]
        public string Telefon { get; set; } = null!;

        public string? Fax { get; set; }

        public string? Web { get; set; }

        [Required]
        public string Email { get; set; } = null!;

        public string? ZiroRacun { get; set; }

        public string? Napomena { get; set; }

    }
}
