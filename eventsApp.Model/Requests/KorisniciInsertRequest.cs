using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class KorisniciInsertRequest
    {
        [Required(ErrorMessage = "Ime je obavezno")]
        public string Ime { get; set; } = null!;
        [Required(ErrorMessage = "Prezime je obavezno")]
        public string Prezime { get; set; } = null!;

        [Required(ErrorMessage = "Email je obavezan")]
        public string Email { get; set; } = null!;

        public string? Telefon { get; set; }
        [Required(ErrorMessage ="Korisnicko ime je obavezno")]
        public string KorisnickoIme { get; set; } = null!;

        public string? Adresa { get; set; }

        public string? Drzava { get; set; }

        //public byte[]? Slika { get; set; }
        [Required(ErrorMessage = "Lozinka je obavezna")]
        [Compare("PasswordPotvrda", ErrorMessage="Lozinke nisu iste")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Potvrda lozinke je obavezna")]
        public string PasswordPotvrda { get; set; }

        public int? Uloga { get; set; }
    }
}
