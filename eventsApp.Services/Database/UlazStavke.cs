using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class UlazStavke
{
    public int UlazStavkaId { get; set; }

    public int UlazId { get; set; }

    public int TipKarteId { get; set; }

    public int Kolicina { get; set; }

    public decimal Cijena { get; set; }

    public byte[] KarteInfo { get; set; } = null!;

    public virtual TipKarte TipKarte { get; set; } = null!;

    public virtual Ulazi Ulaz { get; set; } = null!;
}
