using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class NarudzbaInsertRequest
    {
        [Required(ErrorMessage = "Ime je obavezno")]
        public string Ime { get; set; } = null!;

        [Required(ErrorMessage = "Prezime je obavezno")]
        public string Prezime { get; set; } = null!;

        [Required(ErrorMessage = "Email je obavezan")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "Telefon je obavezan")]
        public string Telefon { get; set; } = null!;

        [Required(ErrorMessage = "Adresa je obavezna")]
        public string Adresa { get; set; } = null!;

        [Required(ErrorMessage = "Postanski broj je obavezan")]
        public int PostanskiBroj { get; set; }

        [Required(ErrorMessage = "Grad je obavezan")]
        public string Grad { get; set; } = null!;

        [Required(ErrorMessage = "Drzava je obavezna")]
        public string Drzava { get; set; } = null!;

        [Required(ErrorMessage = "KorisnikId je obavezan")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Tip karte je obavezan")]
        public string Tip { get; set; } = null!;

        [Required(ErrorMessage = "Lista karata je obavezna")]
        public List<ValidTipKarte> ListaKarata { get; set; } = null!;

        [Required(ErrorMessage = "Cijena je obavezna")]
        public decimal Cijena { get; set; }


    }
}
