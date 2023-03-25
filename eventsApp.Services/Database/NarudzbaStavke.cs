using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class NarudzbaStavke
{
    public int NarudzbaStavkaId { get; set; }

    public int NarudzbaId { get; set; }

    public int TipKarteId { get; set; }

    public int Kolicina { get; set; }

    public decimal Cijena { get; set; }

    public virtual Narudzbe Narudzba { get; set; } = null!;

    public virtual TipKarte TipKarte { get; set; } = null!;
}
