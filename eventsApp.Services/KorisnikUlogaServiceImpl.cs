using AutoMapper;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class KorisnikUlogaServiceImpl : BaseCRUDService<Model.KorisniciUloge, Model.KorisniciUloge, Database.KorisniciUloge, BaseSearchObject, Model.KorisniciUloge, Model.KorisniciUloge>, IKorisnikUlogaService
    {
        ILogger<KorisnikUlogaServiceImpl> _logger;

        public KorisnikUlogaServiceImpl(EventsDbContext context, IMapper mapper, ILogger<KorisnikUlogaServiceImpl> logger) : base(context, mapper)
        {
            _logger = logger;
        }

    }
}
