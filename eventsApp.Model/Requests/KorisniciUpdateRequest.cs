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

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public bool? Status { get; set; }
        public string? Adresa { get; set; }

        public string? Lozinka { get; set; }

        public string? LozinkaPotvrda { get; set; }

        public string? Drzava { get; set; }

        public byte[]? Slika { get; set; }
    }
}
