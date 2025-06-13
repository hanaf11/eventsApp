using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
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
    public class DobavljaciServiceImpl : BaseCRUDService<Model.Dobavljaci, Model.Dobavljaci, Database.Dobavljaci, DobavljaciSearchObject, DobavljaciInsertRequest, DobavljaciUpdateRequest>,IDobavljaciService
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
            if (!string.IsNullOrWhiteSpace(search?.Dogadjaj))
            {
                query = query. Where(x => x.Dogadjajis.Any(y => y.Naziv.StartsWith(search.Dogadjaj)));

            }
            if (search?.Active!=null && search?.Active==true)
            {
                query = query.Where(x => x.Status==true);

            }
            return base.AddFilter(query, search);  
        }

        public override async Task BeforeInsert(Database.Dobavljaci entity, DobavljaciInsertRequest insert)
        {
           await base.BeforeInsert(entity, insert);
            entity.Status = true;
        }

        public async Task<Model.Dobavljaci> ChangeStatus(int id,bool status)
        {
            var entity = await _context.Dobavljacis.FindAsync(id);

            if (entity == null) throw new UserException("Dobavljac nije pronadjen");

            entity.Status = status;

            await _context.SaveChangesAsync();

            return _mapper.Map<Model.Dobavljaci>(entity);
        }
    }
}
