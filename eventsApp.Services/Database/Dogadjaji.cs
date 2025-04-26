using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Dogadjaji
{
    public int DogadjajId { get; set; }

    public string Naziv { get; set; } = null!;

    public DateTime DatumOd { get; set; }

    public DateTime DatumDo { get; set; }

    public string? Program { get; set; }

    public byte[]? ProgramSlika { get; set; }

    public byte[] Naslovna { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public string? Website { get; set; }

    public string Lokacija { get; set; } = null!;

    public byte[]? LokacijaSlika { get; set; }

    public int? DobavljacId { get; set; }

    public int KategorijaId { get; set; }

    public string Status { get; set; } = null!;

    public int? PodkategorijaId { get; set; }

    public string? Organizator { get; set; }

    public virtual Dobavljaci? Dobavljac { get; set; }

    public DateTime Created { get; set; }

    public double Latitude { get; set; }

    public double Longitude { get; set; }
    public virtual ICollection<HistorijaPregledum> HistorijaPregleda { get; } = new List<HistorijaPregledum>();

    public virtual Kategorije Kategorija { get; set; } = null!;

    public virtual ICollection<Komentari> Komentaris { get; } = new List<Komentari>();

    public virtual ICollection<Saving> Savings { get; } = new List<Saving>();

    public virtual ICollection<Slike> Slikes { get; } = new List<Slike>();

    public virtual ICollection<TipKarte> TipKartes { get; } = new List<TipKarte>();
}
