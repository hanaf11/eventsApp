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
using Microsoft.Extensions.Logging;
using eventsApp.Model;

namespace eventsApp.Services
{
    public class KomentariServiceImpl : BaseService<Model.Komentari, Model.Komentari, Database.Komentari, KomentarSearchObject>, IKomentariService
    {
        ILogger<KomentariServiceImpl> _logger;
        public KomentariServiceImpl(EventsDbContext context, IMapper mapper, ILogger<KomentariServiceImpl> logger) : base(context, mapper)
        {
            _logger = logger;
        }

        public override IQueryable<Database.Komentari> AddFilter(IQueryable<Database.Komentari> query, KomentarSearchObject? search = null)
        {
            if (search?.DogadjajId != null)
            {
                query = query.Where(x => x.DogadjajId == search.DogadjajId);
            }

            return base.AddFilter(query, search);
        }


        public override IQueryable<Database.Komentari> AddInclude(IQueryable<Database.Komentari> query, KomentarSearchObject? search = null)
        {
            if (search?.KorisnikIncluded == true)
            {
                query = query.Include("Korisnik");
            }
            return base.AddInclude(query, search);
        }

        public async Task<PagedResult<Model.Komentari>> Post(KomentarInsertObject insert)
        {
            var set = _context.Set<Database.Komentari>();

            await ValidateRequest(insert);

            Database.Komentari entity = _mapper.Map<Database.Komentari>(insert);
            entity.Vrijeme = DateTime.Now;
            entity.Dogadjaj = await _context.Dogadjajis.FindAsync(insert.DogadjajId);
            entity.Korisnik = await _context.Korisnicis.FindAsync(insert.KorisnikId);

            set.Add(entity);
            await _context.SaveChangesAsync();

            return await Get(new KomentarSearchObject {DogadjajId=insert.DogadjajId, KorisnikIncluded = true });
        }

            private async Task ValidateRequest(KomentarInsertObject insert)
        {
            bool dogadjajExists = await _context.Dogadjajis.AnyAsync(d => d.DogadjajId == insert.DogadjajId);
            if (!dogadjajExists)
            {
                throw new Model.UserException("Dogadjaj nije pronadjen");
            }

            bool korisnikExists = await _context.Korisnicis.AnyAsync(k => k.KorisnikId == insert.KorisnikId);
            if (!korisnikExists)
            {
                throw new Model.UserException("Korisnik nije pronadjen");
            }
        }

        public async Task<List<Dictionary<string, object>>> GetMostActiveUsers()
        {
            var topUsers = await _context.Komentaris
                .GroupBy(k => k.KorisnikId)
                .Select(group => new
                {
                    KorisnikId = group.Key,
                    KomentariCount = group.Count()
                })
                .OrderByDescending(x => x.KomentariCount)
                .Take(3)
                .ToListAsync();

            var result = await _context.Korisnicis
                .Where(k => topUsers.Select(u => u.KorisnikId).Contains(k.KorisnikId))
                .Select(k => new
                {
                    k.KorisnikId,
                    k.Ime
                })
                .ToListAsync();

            return topUsers
                .Join(result,
                      topUser => topUser.KorisnikId,
                      korisnik => korisnik.KorisnikId,
                      (topUser, korisnik) => new Dictionary<string, object>
                      {
                  { "korisnik", korisnik.Ime },
                  { "komentari", topUser.KomentariCount }
                      })
                .ToList();
        }



    }

}




