using AutoMapper;
using eventsApp.Model;
using eventsApp.Model.Requests;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class InitialEventState:BaseState
    {
        protected readonly ITipKarteService _tipKarteService;
        protected readonly IGalerijaService _gallery;
        public InitialEventState(IServiceProvider serviceProvider,Database.EventsDbContext context, IMapper mapper, IGalerijaService gallery, ITipKarteService tipKarteService) : base(serviceProvider, context, mapper)
        {
            _gallery = gallery;
            _tipKarteService = tipKarteService;
        }

        public override async Task<Dogadjaji> Insert(DogadjajiInsertRequest request)
        {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = _mapper.Map<Database.Dogadjaji>(request);
            entity.Status = "DRAFT";
            entity.Created= DateTime.Now;

            set.Add(entity);

            await _context.SaveChangesAsync();
            if (request.Galerija?.Count > 0)
            {
                await _gallery.InsertGallery(entity.DogadjajId, request.Galerija);
            }

            if ( request.TipoviKarata?.Count > 0)
                {
                await _tipKarteService.InsertTipKarte(entity.DogadjajId, request.TipoviKarata);
            }

            return _mapper.Map<Dogadjaji>(entity);
        }


        public override List<string> AllowedActions(Database.Dogadjaji entity)
        {
            return new List<string>() { nameof(Insert)};
        }
    }
}
