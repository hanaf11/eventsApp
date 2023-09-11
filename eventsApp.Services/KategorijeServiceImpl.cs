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

namespace eventsApp.Services
{
    public class KategorijeServiceImpl : BaseCRUDService<Model.Kategorije,Model.Kategorije, Database.Kategorije, KategorijeSearchObject, KategorijeInsertRequest, KategorijeUpdateRequest>, IKategorijeService
    {
        public KategorijeServiceImpl(EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
        }

       
    }
}
