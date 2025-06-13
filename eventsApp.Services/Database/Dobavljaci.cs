using System;
using System.Collections.Generic;

namespace eventsApp.Services.Database;

public partial class Dobavljaci
{
    public int DobavljacId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Adresa { get; set; } = null!;

    public string Telefon { get; set; } = null!;

    public string? Fax { get; set; }

    public string? Web { get; set; }

    public string Email { get; set; } = null!;

    public string ZiroRacun { get; set; } = null!;

    public string? Napomena { get; set; }

    public bool? Status { get; set; }

    public virtual ICollection<Dogadjaji> Dogadjajis { get; } = new List<Dogadjaji>();

}
