using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class DobavljaciServiceImpl : IDobavljaciService
    {
        EventsDbContext _context;

        public DobavljaciServiceImpl(EventsDbContext context)
        {
            _context = context;
        }

       List<Dobavljaci> DobavljaciList = new List<Dobavljaci>() {new Dobavljaci() { Id=1, Naziv="Dobavljac 1",Adresa="Adresa1",
                Email="dobavljac1@gmail.com",Status=true,Faks="12124",Napomena="test",Telefon="06111110",Web="dobavljac1.com",
                ZiroRacun="6465466" }, new Dobavljaci(){ Id=2, Naziv="Dobavljac 2",Adresa="Adresa2",
                Email="dobavljac2@gmail.com",Status=true,Faks="1217465",Napomena="test",Telefon="06565110",Web="dobavljac2.com",
                ZiroRacun="67498986566" } };

        public IList<Dobavljaci> Get()
        {
            var list = _context.Dobavljacis.ToList();
            return DobavljaciList;
        }

        public Dobavljaci GetById(int id)
        {
            return DobavljaciList.FirstOrDefault(x => x.Id == id);
        }
    }
}
