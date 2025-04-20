using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Narudzbe
    {
        public string BrojNarudzbe { get; set; } = null!;

        public int KorisnikId { get; set; }

        public DateTime Datum { get; set; }

        public decimal Cijena { get; set; }

        public string Email { get; set; } = null!;

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Telefon { get; set; } = null!;

        public string? Adresa { get; set; }

        public int PostanskiBroj { get; set; }

        public string Grad { get; set; } = null!;

        public string? Drzava { get; set; }

        public string Tip { get; set; } = null!;
        public string KorisnickoIme { get; set; } = null!;

    }
}
