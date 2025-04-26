using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model
{
    public class DogadjajiListResponse
    {
        public int DogadjajId { get; set; }

        public string Naziv { get; set; } = null!;

        public DateTime DatumOd { get; set; }

        public DateTime DatumDo { get; set; }

        public string Lokacija { get; set; } = null!;

        public string? Organizator { get; set; }

        public Kategorije? Kategorija { get; set; }

        public byte[] Naslovna { get; set; }

        public string Status { get; set; }

        public Dobavljaci Dobavljac { get; set; }

        public double? Latitude { get; set; }

        public double? Longitude { get; set; }


    }
}
