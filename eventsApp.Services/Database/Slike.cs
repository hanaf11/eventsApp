using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Slike
{
    public int SlikaId { get; set; }

    public string? Opis { get; set; }

    public byte[] Slika { get; set; } = null!;

    public int DogadjajId { get; set; }

    public virtual Dogadjaji Dogadjaj { get; set; } = null!;
}
