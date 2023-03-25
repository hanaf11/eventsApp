using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class Dobavljaci
    {
        public int Id { get; set; }
        public string Naziv { get; set; }
        public string Adresa { get; set; }
        public string Telefon { get; set; }
        public string Faks { get; set; }
        public string Web { get; set; }
        public string Email { get; set; }
        public string ZiroRacun { get; set; }
        public string Napomena { get; set; }
        public Boolean Status { get; set; }
    }
}
