using AutoMapper;
using eventsApp.Model;
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
    public class UlogaServiceImpl:BaseService<Model.Uloge, Model.Uloge, Database.Uloge, UlogaSearchObject>, IUlogaService
    {
        public UlogaServiceImpl(EventsDbContext context, IMapper mapper):base(context,mapper)
        {
        }
    }
}
