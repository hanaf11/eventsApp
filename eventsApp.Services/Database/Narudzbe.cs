using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Narudzbe
{
    public int NarudzbaId { get; set; }

    public string BrojNarudzbe { get; set; } = null!;

    public int KorisnikId { get; set; }

    public DateTime Datum { get; set; }

    public bool? Otkazano { get; set; }

    public string Tip { get; set; } = null!;

    public decimal Cijena { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Telefon { get; set; } = null!;

    public string? Adresa { get; set; }

    public int PostanskiBroj { get; set; }

    public string Grad { get; set; } = null!;

    public string? Drzava { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual ICollection<NarudzbaStavke> NarudzbaStavkes { get; } = new List<NarudzbaStavke>();
}
