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

    public decimal IznosBezPdv { get; set; }

    public decimal IznosSaPdv { get; set; }

    public string? Adresa { get; set; }

    public string? Drzava { get; set; }

    public virtual Korisnici Korisnik { get; set; } = null!;

    public virtual ICollection<NarudzbaStavke> NarudzbaStavkes { get; } = new List<NarudzbaStavke>();
}
