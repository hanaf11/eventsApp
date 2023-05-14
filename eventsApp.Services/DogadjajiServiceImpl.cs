using AutoMapper;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class DogadjajiServiceImpl : BaseCRUDService<Model.Dogadjaji, Database.Dogadjaji, DogadjajiSearchObject, Model.Requests.DogadjajiInsertRequest, Model.Requests.DogadjajiUpdateRequest>, IDogadjajiService
    {
        public DogadjajiServiceImpl(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
        }
    }
}
