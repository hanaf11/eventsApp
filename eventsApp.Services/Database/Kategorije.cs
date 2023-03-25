using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Kategorije
{
    public int KategorijaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Opis { get; set; }

    public virtual ICollection<Dogadjaji> Dogadjajis { get; } = new List<Dogadjaji>();

    public virtual ICollection<Podkategorije> Podkategorijes { get; } = new List<Podkategorije>();

    public virtual ICollection<Pracenje> Pracenjes { get; } = new List<Pracenje>();
}
