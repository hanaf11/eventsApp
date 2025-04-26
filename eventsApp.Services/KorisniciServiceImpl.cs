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
        protected readonly INotificationService _notificationService;
        protected readonly IKomentariService _komentariService;
        protected readonly IPracenjeService _pracenjeService;
        protected readonly INarudzbaService _narudzbaService;

        public KorisniciServiceImpl(EventsDbContext context, IMapper mapper, ILogger<KorisniciServiceImpl> logger, INotificationService notificationService, IKomentariService komentariService, IPracenjeService pracenjeService, INarudzbaService narudzbaService, IHistorijaPregledaService historijaPregledaService) : base(context, mapper)
        {
           _logger = logger;
            _notificationService = notificationService;
            _komentariService = komentariService;
            _pracenjeService = pracenjeService;
            _narudzbaService = narudzbaService;
        }

        public override async Task BeforeInsert(Database.Korisnici entity, KorisniciInsertRequest insert)
        {
            _logger.LogInformation($"Adding user: {entity.KorisnickoIme}");
            await base.BeforeInsert(entity, insert);
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, insert.Password);
            entity.Created=DateTime.Now;
 
        }

        public override async Task ValidateInsert(KorisniciInsertRequest insert)
        {
            await base.ValidateInsert(insert);
            Korisnici existingUsername = await _context.Korisnicis.FirstOrDefaultAsync(x => x.KorisnickoIme == insert.KorisnickoIme);
            if (existingUsername != null)
            {
                throw new Model.UserException("Korisničko ime je zauzeto");
            }
            Korisnici existingEmail = await _context.Korisnicis.FirstOrDefaultAsync(x => x.Email == insert.Email);
            if (existingEmail != null)
            {
                throw new Model.UserException("Već postoji račun sa tom email adresom");
            }
        }

       /* public override async Task BeforeUpdate(Database.Korisnici entity, KorisniciUpdateRequest update)
        {
            base.BeforeUpdate(entity, update);
            if (update.Lozinka != update.LozinkaPotvrda)
            {
                throw new Exception("Lozinka i LozonkaPotvrda moraju biti iste");
            }
            entity.LozinkaSalt = GenerateSalt();
            entity.LozinkaHash = GenerateHash(entity.LozinkaSalt, update.Lozinka);

        }*/

        public override async Task AfterInsert(KorisniciInsertRequest insert)
        {
            _notificationService.SendRegisteredMail(insert.Email,insert.Ime);
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

            if (entity == null)
            {
                throw new Model.UserException("Korisnik nije pronadjen");
            }

            var hash = GenerateHash(entity.LozinkaSalt, password);

            if (hash != entity.LozinkaHash)
            {
                throw new Model.UserException("Lozinka nije ispravna");
            }

            return _mapper.Map<Model.Korisnici>(entity);
        }

        public async Task<Model.KorisniciReportResponse> GetReportData(KorisniciReportSearchObject? search)
        {
            var response = new Model.KorisniciReportResponse();
            if (search == null) return response;

            if (search.NumberOfRegistered != null && search.NumberOfRegistered == true)
            {
                response.NumberOfRegistered = await GetNumberOfRegistered();
            }
            if (search.MostOrdersUsers != null && search.MostOrdersUsers == true)
            {
                response.MostOrdersUsers = await _narudzbaService.GetMostOrdersUsers();
            }
            if (search.MostActiveUsers != null && search.MostActiveUsers == true)
            {
                response.MostActiveUsers = await _komentariService.GetMostActiveUsers();
            }
            if (search.MostSubscribedCategories != null && search.MostSubscribedCategories == true)
            {
                response.MostSubscribedCategories = await _pracenjeService.GetMostSubscribedCategories();
            }
            return response;
        }

        private async Task<List<Dictionary<string, object>>> GetNumberOfRegistered()
        {
            var currentDate = DateTime.Now;

            var queryResult = await _context.Korisnicis
                .GroupBy(k => k.Created >= currentDate.AddMonths(-1) ? "Month" : "All time")
                .Select(group => new
                {
                    Time = group.Key,
                    Registered = group.Count()
                })
                .ToListAsync();

            var monthCount = queryResult.FirstOrDefault(x => x.Time == "Month")?.Registered ?? 0;
            var allTimeCount = queryResult.Sum(x => x.Registered);

            return new List<Dictionary<string, object>>{
        new Dictionary<string, object> { { "time", "Month" }, { "registered", monthCount } },
        new Dictionary<string, object> { { "time", "All time" }, { "registered", allTimeCount } } };
        }

        public async Task<Model.Korisnici> UpdatePicture(int korisnikId, byte[] slika)
        {
            if (slika == null || slika.Length == 0)
            {
                throw new Model.UserException("Invalid image data.");
            }

                var korisnik = await _context.Set<Database.Korisnici>().FindAsync(korisnikId);
                if (korisnik == null)
                {
                   throw new Model.UserException("Korisnik nije pronađen.");
                }

                korisnik.Slika = slika;

                await _context.SaveChangesAsync();

                return _mapper.Map<Model.Korisnici>(korisnik);   

        }


    }
}
