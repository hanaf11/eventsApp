using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public partial class Korisnici
    {
        public int KorisnikId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string Telefon { get; set; } = null!;

        public string KorisnickoIme { get; set; } = null!;

        public bool? Status { get; set; }

        public DateTime Created { get; set; }

        public string Adresa { get; set; } = null!;

        public string? Drzava { get; set; }

        public byte[]? Slika { get; set; }

        public virtual ICollection<KorisniciUloge> KorisniciUloges { get; } = new List<KorisniciUloge>();

        public List<string>? Uloge { get; set; }

        public virtual ICollection<Pracenje> Pracenjes { get; } = new List<Pracenje>();

        public virtual ICollection<Narudzbe> Narudzbes { get; } = new List<Narudzbe>();
    }
}
