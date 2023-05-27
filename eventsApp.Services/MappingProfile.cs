using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;

namespace eventsApp.Services
{
    public class MappingProfile:Profile
    {
        public MappingProfile()
        {
           CreateMap<Database.Korisnici, Model.Korisnici>();
            CreateMap<Model.Requests.KorisniciInsertRequest,Database.Korisnici>();
            CreateMap<Model.Requests.KorisniciUpdateRequest, Database.Korisnici>();
            CreateMap<Database.Dobavljaci, Model.Dobavljaci>();
            CreateMap<Database.Kategorije, Model.Kategorije>();
            CreateMap<Database.KorisniciUloge, Model.KorisniciUloge>();
            CreateMap<Database.Uloge, Model.Uloge>();
            CreateMap<Database.Pracenje, Model.Pracenje>();
            CreateMap<Database.Dogadjaji, Model.Dogadjaji>();
            CreateMap<Model.Requests.DogadjajiInsertRequest, Database.Dogadjaji>();
            CreateMap<Model.Requests.DogadjajiUpdateRequest, Database.Dogadjaji>();
        }
    }
}
