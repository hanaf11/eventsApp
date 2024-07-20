using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class SavingObject
    {
        [Required]
        public int KorisnikId { get; set; }
        [Required]
        public int DogadjajId { get; set; }

    }
}

