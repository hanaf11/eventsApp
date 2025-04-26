using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class TipKarte
{
    public int TipKarteId { get; set; }

    public string Naziv { get; set; } = null!;

    public decimal Cijena { get; set; }

    public int Stanje { get; set; }

    public bool NumerisanjeSjedista { get; set; }

    public int? DogadjajId { get; set; }

    public virtual Dogadjaji? Dogadjaj { get; set; }

    public virtual ICollection<Karte> Kartes { get; } = new List<Karte>();

    public virtual ICollection<NarudzbaStavke> NarudzbaStavkes { get; } = new List<NarudzbaStavke>();
}
