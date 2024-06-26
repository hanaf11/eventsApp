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
using eventsApp.Model;

namespace eventsApp.Services
{
    public class KategorijeServiceImpl : BaseCRUDService<Model.Kategorije,Model.Kategorije, Database.Kategorije, KategorijeSearchObject, KategorijeInsertRequest, KategorijeUpdateRequest>, IKategorijeService
    {
        public KategorijeServiceImpl(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.Kategorije> AddFilter(IQueryable<Database.Kategorije> query, KategorijeSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
            if (!string.IsNullOrWhiteSpace(search?.fts))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.fts));
            }
            return filteredQuery;
        }

        public override  void BeforeDelete(Database.Kategorije entity)
        {
            bool notEmpty = _context.Dogadjajis.Where(e=>e.KategorijaId==entity.KategorijaId).Count() > 0;

            if (notEmpty)
            {
                throw new UserException("Kategorija se ne moze obrisati jer ima pripadajuce dogadjaje.");
            }
        }
    }
}
