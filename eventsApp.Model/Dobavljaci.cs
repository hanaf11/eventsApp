using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Dobavljaci
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
        public Boolean Status { get; set; }
    }
}
