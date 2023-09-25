using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class SlikeInsertRequest
    {
        public int? SlikaId { get; set; }

        [Required]
        public byte[] Slika { get; set; } = null!;

        public int DogadjajId { get; set; }

    }
}
