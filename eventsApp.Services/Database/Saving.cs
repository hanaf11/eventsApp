using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Saving
{
    public int SaveId { get; set; }

    public int KorisnikId { get; set; }

    public int DogadjajId { get; set; }

    public DateTime Vrijeme { get; set; }

    public virtual Dogadjaji Dogadjaj { get; set; } = null!;

    public virtual Korisnici Korisnik { get; set; } = null!;
}
