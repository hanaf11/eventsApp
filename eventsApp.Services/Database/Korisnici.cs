using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Korisnici
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string? Email { get; set; }

    public string? Telefon { get; set; }

    public string KorisnickoIme { get; set; } = null!;

    public string LozinkaHash { get; set; } = null!;

    public string? LozinkaSalt { get; set; }

    public bool? Status { get; set; }

    public DateTime Created { get; set; }

    public string? Adresa { get; set; }

    public string? Drzava { get; set; }

    public byte[] Slika { get; set; } = null!;

    public virtual ICollection<HistorijaPregledum> HistorijaPregleda { get; } = new List<HistorijaPregledum>();

    public virtual ICollection<Komentari> Komentaris { get; } = new List<Komentari>();

    public virtual ICollection<KorisniciUloge> KorisniciUloges { get; } = new List<KorisniciUloge>();

    public virtual ICollection<Narudzbe> Narudzbes { get; } = new List<Narudzbe>();

    public virtual ICollection<Pracenje> Pracenjes { get; } = new List<Pracenje>();

    public virtual ICollection<Saving> Savings { get; } = new List<Saving>();

    public virtual ICollection<Ulazi> Ulazis { get; } = new List<Ulazi>();
}
