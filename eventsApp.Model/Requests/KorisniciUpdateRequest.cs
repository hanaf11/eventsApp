using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class KorisniciUpdateRequest
    {
        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string Telefon { get; set; } = null!;

        public bool? Status { get; set; }
        public string Adresa { get; set; } = null!;

        public string? Drzava { get; set; }

    }
}
