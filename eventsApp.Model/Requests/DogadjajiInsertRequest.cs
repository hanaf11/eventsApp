using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class DogadjajiInsertRequest
    {
        [Required(AllowEmptyStrings =false)]
        [MinLength(1)]
        public string Naziv { get; set; } = null!;
        [Required]
        public DateTime DatumOd { get; set; }
        [Required]
        public DateTime DatumDo { get; set; }

        public string? Program { get; set; }

        public byte[] Naslovna { get; set; } = null!;

        public string Opis { get; set; } = null!;

        public string? Website { get; set; }

        public string Lokacija { get; set; } = null!;

        public byte[]? LokacijaSlika { get; set; }

        public int? DobavljacId { get; set; }

        public int KategorijaId { get; set; }

        public int? PodkategorijaId { get; set; }

        public string? Organizator { get; set; }
    }
}
