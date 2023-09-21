using AutoMapper;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class PodkategorijeServiceImpl : BaseCRUDService<Model.Podkategorije, Model.Podkategorije, Database.Podkategorije, PodkategorijeSearchObject, PodkategorijeCreateRequest, PodkategorijeUpdateRequest>, IPodkategorijeService
    {
        public PodkategorijeServiceImpl(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Podkategorije> AddFilter(IQueryable<Database.Podkategorije> query, PodkategorijeSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.Naziv));
            }
            if (search?.KategorijaId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KategorijaId.Equals(search.KategorijaId));
            }
            return filteredQuery;
        }


    }
}
