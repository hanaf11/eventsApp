using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class DogadjajiUpdateRequest
    {

        public string Naziv { get; set; } = null!;

        public DateTime? DatumOd { get; set; }

        public DateTime? DatumDo { get; set; }

        public string? Program { get; set; }

        public byte[]? Naslovna { get; set; } = null!;

        public string? Opis { get; set; } = null!;

        public string? Website { get; set; }

        public string? Lokacija { get; set; } = null!;

        public byte[]? LokacijaSlika { get; set; }

        public int? KategorijaId { get; set; } = null!;

        public int? PodkategorijaId { get; set; }

         public List<SlikeInsertRequest>? Galerija { get; set; }

        //public List<byte[]>? Galerija { get; set; }

        public double? Latitude { get; set; }

        public double? Longitude { get; set; }
        public byte[]? ProgramSlika { get; set; }
    }
}
