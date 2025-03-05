using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class SavingServiceImpl:ISavingService
    {
        protected EventsDbContext _context;
        protected IMapper _mapper { get; set; }
        public SavingServiceImpl(EventsDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task<bool> IsSaved(SavingObject search)
        {
            return await _context.Set<Database.Saving>().AnyAsync(s => s.KorisnikId == search.KorisnikId && s.DogadjajId == search.DogadjajId);

        }

        public async Task<bool> Save(SavingObject insert)
        {
            var set = _context.Set<Database.Saving>();

            await ValidateRequest(insert, true);

            Database.Saving entity = _mapper.Map<Database.Saving>(insert);
            entity.Vrijeme = DateTime.Now;
            entity.Dogadjaj = await _context.Dogadjajis.FindAsync(insert.DogadjajId);
            entity.Korisnik = await _context.Korisnicis.FindAsync(insert.KorisnikId);

            set.Add(entity);
            await _context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> Delete(SavingObject request)
        {
            await ValidateRequest(request, false);

            var entity = await _context.Savings.Where(s => s.KorisnikId == request.KorisnikId).Where(s => s.DogadjajId == request.DogadjajId).FirstOrDefaultAsync();

            _context.Savings.Remove(entity);

            await _context.SaveChangesAsync();

            return false;
        }

        public async Task<List<Model.DogadjajiListResponse>> GetSavedEvents(int korisnikId)
        {
            bool korisnikExists = await _context.Korisnicis.AnyAsync(k => k.KorisnikId == korisnikId);
            if (!korisnikExists)
            {
                throw new Model.UserException("Korisnik nije pronadjen");
            }
            var dogadjajiList = await _context.Korisnicis.Where(k => k.KorisnikId == korisnikId).SelectMany(k => k.Savings)
             .Include(s => s.Dogadjaj.Kategorija).OrderByDescending(s => s.Vrijeme).Select(s => s.Dogadjaj).ToListAsync();
            return _mapper.Map<List<Model.DogadjajiListResponse>>(dogadjajiList);
        }

        private async Task ValidateRequest(SavingObject insert, bool saveRequest)
        {
            bool dogadjajExists = await _context.Dogadjajis.AnyAsync(d => d.DogadjajId == insert.DogadjajId);
            if (!dogadjajExists)
            {
                throw new UserException("Dogadjaj nije pronadjen");
            }

            bool korisnikExists = await _context.Korisnicis.AnyAsync(k => k.KorisnikId == insert.KorisnikId);
            if (!korisnikExists)
            {
                throw new UserException("Korisnik nije pronadjen");
            }

            bool savingExists = await IsSaved(insert);
            if (saveRequest && savingExists)
            {
                throw new UserException("Dogadjaj je vec sacuvan");
            }
            if (!saveRequest && !savingExists)
            {
                throw new UserException("Dogadjaj nije sacuvan");
            }
        }

        public async Task<bool> DeleteByDogadjaj(int dogadjajId)
        {
            var savingsToDelete = _context.Savings.Where(s => s.DogadjajId == dogadjajId);

            _context.Savings.RemoveRange(savingsToDelete);

            await _context.SaveChangesAsync();

            return true;
        }
    }
}
