using AutoMapper;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;

using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class DobavljaciServiceImpl : BaseService<Model.Dobavljaci,Database.Dobavljaci, DobavljaciSearchObject>,IDobavljaciService
    {

       public DobavljaciServiceImpl(EventsDbContext context, IMapper mapper):base(context,mapper)
        {
        }

        public override IQueryable<Database.Dobavljaci> AddFilter(IQueryable<Database.Dobavljaci> query, DobavljaciSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                query = query.Where(x => x.Naziv.StartsWith(search.Naziv));
            }
            if (!string.IsNullOrWhiteSpace(search?.Adresa))
            {
                query = query.Where(x => x.Adresa.Contains(search.Adresa));

            }
            return base.AddFilter(query, search);  
        }
    }
}
