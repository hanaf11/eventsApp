using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class Dogadjaji
    {
        public int DogadjajId { get; set; }

        public string Naziv { get; set; } = null!;

        public DateTime DatumOd { get; set; }

        public DateTime DatumDo { get; set; }

        public string? Program { get; set; }

        public byte[]? ProgramSlika { get; set; }

        public byte[] Naslovna { get; set; } = null!;

        public string Opis { get; set; } = null!;

        public string? Website { get; set; }

        public string Lokacija { get; set; } = null!;

        public byte[]? LokacijaSlika { get; set; }

        public int? DobavljacId { get; set; }

        public int KategorijaId { get; set; }

        public int? PodkategorijaId { get; set; }

        public string Status { get; set; }

        public string? Organizator { get; set; }

        public double? Latitude { get; set; }

        public double? Longitude { get; set; }

        public Kategorije? Kategorija { get; set; }


    }
}
