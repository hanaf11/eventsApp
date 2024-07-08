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
    public class PracenjeServiceImpl:IPracenjeService
    {
        protected EventsDbContext _context;
        protected IMapper _mapper { get; set; }

        protected readonly IDogadjajiService _dogadjajiService;
        public PracenjeServiceImpl(EventsDbContext context, IMapper mapper, IDogadjajiService dogadjajiService)
        {
            _context = context;
            _mapper = mapper;
            _dogadjajiService = dogadjajiService;
        }

        public async Task<bool> IsFollowing(PracenjeObject search)
        {
            return await _context.Set<Database.Pracenje>().AnyAsync(p => p.KorisnikId == search.KorisnikId && p.KategorijaId == search.KategorijaId);
       
        }

        public async Task<bool> Follow(PracenjeObject insert)
        {
            var set = _context.Set<Database.Pracenje>();

            await ValidateRequest(insert,true);

            Database.Pracenje entity = _mapper.Map<Database.Pracenje>(insert);
            entity.Vrijeme=DateTime.Now;
            entity.Kategorija = await _context.Kategorijes.FindAsync(insert.KategorijaId);
            entity.Korisnik = await _context.Korisnicis.FindAsync(insert.KorisnikId);

            set.Add(entity);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> Unfollow(PracenjeObject request)
        {
           await ValidateRequest(request, false);

            var entity = await _context.Pracenjes.Where(p => p.KorisnikId == request.KorisnikId).Where(p => p.KategorijaId == request.KategorijaId).FirstOrDefaultAsync();

            _context.Pracenjes.Remove(entity);

            await _context.SaveChangesAsync();

            return false;
        }

        private async Task ValidateRequest(PracenjeObject insert, bool followRequest)
        {
            bool kategorijaExists = await _context.Kategorijes.AnyAsync(k => k.KategorijaId == insert.KategorijaId);
            if (!kategorijaExists)
            {
                throw new UserException("Kategorija nije pronadjena");
            }

            bool korisnikExists = await _context.Korisnicis.AnyAsync(k => k.KorisnikId == insert.KorisnikId);
            if (!korisnikExists)
            {
                throw new UserException("Korisnik nije pronadjen");
            }

            bool pracenjeExists = await IsFollowing(insert);
            if (followRequest && pracenjeExists)
            {
                throw new UserException("Pracenje vec postoji");
            }
            if(!followRequest && !pracenjeExists)
            {
                throw new UserException("Pracenje ne postoji");
            }
        }

      
    }
}
