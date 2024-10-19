using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Karte
{
    public int KartaId { get; set; }

    public string Sifra { get; set; } = null!;

    public string? Sjediste { get; set; }

    public int? TipKarteId { get; set; }

    public virtual TipKarte? TipKarte { get; set; }
}
