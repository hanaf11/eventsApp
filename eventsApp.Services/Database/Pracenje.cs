using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Pracenje
{
    public int PracenjeId { get; set; }

    public int KorisnikId { get; set; }

    public int KategorijaId { get; set; }

    public DateTime Vrijeme { get; set; }

    public virtual Kategorije Kategorija { get; set; } = null!;

    public virtual Korisnici Korisnik { get; set; } = null!;
}
