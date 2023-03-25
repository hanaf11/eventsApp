using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Podkategorije
{
    public int PodkategorijaId { get; set; }

    public string Naziv { get; set; } = null!;

    public int KategorijaId { get; set; }

    public virtual Kategorije Kategorija { get; set; } = null!;
}
