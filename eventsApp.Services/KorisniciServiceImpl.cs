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


namespace eventsApp.Services
{
    public class KorisniciServiceImpl : BaseCRUDService<Model.KorisniciListResponse, Model.Korisnici, Database.Korisnici, KorisniciSearchObject, KorisniciInsertRequest, KorisniciUpdateRequest>, IKorisniciService
    {
        ILogger<KorisniciServiceImpl> _logger;
        public KorisniciServiceImpl(EventsDbContext context, IMapper mapper, ILogger<KorisniciServiceImpl> logger) : base(context, mapper)
        {
           _logger = logger;
        }

        public override async Task BeforeInsert(Korisnici entity, KorisniciInsertRequest insert)
        {
            _logger.LogInformation($"Adding user: {entity.KorisnickoIme}");
            await base.BeforeInsert(entity, insert);
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
            entity.Created=DateTime.Now;
 
        }

        public override async Task BeforeUpdate(Korisnici entity, KorisniciUpdateRequest update)
        {
            base.BeforeUpdate(entity, update);
            if (update.Lozinka != update.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozonkaPotvrda moraju biti iste");
            }
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, update.Lozinka);

        }

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

            return Convert.ToBase64String(byteArray);
        }

        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }

        public override IQueryable<Korisnici> AddInclude(IQueryable<Korisnici> query, KorisniciSearchObject? search = null)
        {
           if (search?.IsUlogeIncluded == true)
            {
                query = query.Include("KorisniciUloges.Uloga");
            }
            return base.AddInclude(query, search);
        }

        public override IQueryable<Korisnici> AddFilter(IQueryable<Korisnici> query, KorisniciSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.Username))
            {
                query = query.Where(x => x.KorisnickoIme.Contains(search.Username));
            }
            return base.AddFilter(query, search);
        }

        public async Task<Model.Korisnici> Login(string username, string password)
        {
           // var entity = await _context.Korisnicis.Include("KorisniciUloges.Uloga").FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            var entity = await _context.Korisnicis.Include(x=>x.KorisniciUloges).ThenInclude(y=>y.Uloga).FirstOrDefaultAsync(x => x.KorisnickoIme == username);

            if (entity == null) return null;

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                return null;
            }

            return _mapper.Map<Model.Korisnici>(entity);
        }

        public async Task<List<Model.DogadjajiListResponse>> GetEventsFromFollowingCategories(int korisnikId)
        {
            bool korisnikExists = await _context.Korisnicis.AnyAsync(k => k.KorisnikId == korisnikId);
            if (!korisnikExists)
            {
                throw new Model.UserException("Korisnik nije pronadjen");
            }

            var dogadjajiList = await _context.Korisnicis.Where(k => k.KorisnikId == korisnikId).SelectMany(k => k.Pracenjes).Select(p => p.Kategorija).SelectMany(k => k.Dogadjajis).ToListAsync();

            return _mapper.Map<List<Model.DogadjajiListResponse>>(dogadjajiList);
        }
    }
}
