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

        [Required(ErrorMessage = "Telefon je obavezan")]
        public string Telefon { get; set; } = null!;
        [Required(ErrorMessage ="Korisnicko ime je obavezno")]
        public string KorisnickoIme { get; set; } = null!;

        [Required(ErrorMessage = "Adresa je obavezna")]
        public string Adresa { get; set; } = null!;

        public string? Drzava { get; set; }

        [Required(ErrorMessage = "Lozinka je obavezna")]
        [Compare("PasswordPotvrda", ErrorMessage="Lozinke nisu iste")]
        public string Password { get; set; } = null!;

        [Required(ErrorMessage = "Potvrda lozinke je obavezna")]
        public string PasswordPotvrda { get; set; } = null!;

        public int? Uloga { get; set; }
    }
}
