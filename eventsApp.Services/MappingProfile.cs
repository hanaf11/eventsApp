using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using eventsApp.Model.Requests;

namespace eventsApp.Services
{
    public class MappingProfile:Profile
    {
        public MappingProfile()
        {
           CreateMap<Database.Korisnici, Model.Korisnici>();
            CreateMap<Database.Korisnici, Model.KorisniciListResponse>();
            CreateMap<Model.Requests.KorisniciInsertRequest,Database.Korisnici>();
            CreateMap<Model.Requests.KorisniciUpdateRequest, Database.Korisnici>();
            CreateMap<Database.Dobavljaci, Model.Dobavljaci>();
            CreateMap<Model.Requests.DobavljaciInsertRequest, Database.Dobavljaci>();
            CreateMap<Model.Requests.DobavljaciUpdateRequest, Database.Dobavljaci>();
            CreateMap<Database.Kategorije, Model.Kategorije>();
            CreateMap<Database.Podkategorije, Model.Podkategorije>();
            CreateMap<Database.KorisniciUloge, Model.KorisniciUloge>();
            CreateMap<Database.Uloge, Model.Uloge>();
            CreateMap<Database.Pracenje, Model.Pracenje>();
            CreateMap<Database.Dogadjaji, Model.Dogadjaji>();
            CreateMap<Model.Requests.DogadjajiInsertRequest, Database.Dogadjaji>();
            CreateMap<Model.Requests.DogadjajiUpdateRequest, Database.Dogadjaji>();
            CreateMap<Database.Dogadjaji, Model.DogadjajiListResponse>();
            CreateMap<Model.Requests.KategorijeInsertRequest, Database.Kategorije>();
            CreateMap<Model.Requests.KategorijeUpdateRequest, Database.Kategorije>();
            CreateMap<Model.Requests.PodkategorijeCreateRequest, Database.Podkategorije>();
            CreateMap<Model.Requests.PodkategorijeUpdateRequest, Database.Podkategorije>();
            CreateMap<Model.Requests.SlikeInsertRequest, Database.Slike>();
            CreateMap<Database.Slike, Model.Slike>();
            CreateMap<Model.Requests.PracenjeObject, Database.Pracenje>();
            CreateMap<Database.Komentari, Model.Komentari>();
            CreateMap<Model.Requests.KomentarInsertObject, Database.Komentari>();
            CreateMap<Model.Requests.SavingObject, Database.Saving>();
            CreateMap<Model.Requests.TipKarteInsertRequest, Database.TipKarte>();
            CreateMap<Database.TipKarte, Model.TipKarte>();
            CreateMap<Database.Karte, Model.Karta>();
            CreateMap<Model.Requests.NarudzbaInsertRequest, Database.Narudzbe>();
            CreateMap<Database.Narudzbe, Model.Narudzbe>()
            .ForMember(model => model.KorisnickoIme, source => source.MapFrom(src => src.Korisnik.KorisnickoIme));
            CreateMap<Model.ValidTipKarte, Database.NarudzbaStavke>();
            CreateMap<Database.Karte, Model.Karta>();
            CreateMap<Database.NarudzbaStavke, Model.StavkeNarudzbe>()
     .ForMember(model => model.TipKarte, source => source.MapFrom(src => src.TipKarte.Naziv))
     .ForMember(model => model.Dogadjaj, source => source.MapFrom(src => src.TipKarte.Dogadjaj.Naziv));
            CreateMap<Model.KorisniciUloge, Database.KorisniciUloge>();
            CreateMap<Database.KorisniciUloge, Model.KorisniciUloge>();
            CreateMap<Database.Uloge, Model.Uloge>();
        }
    }
}
