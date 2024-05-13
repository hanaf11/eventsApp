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

        protected readonly GalerijaServiceImpl _gallery;
        public InitialEventState(IServiceProvider serviceProvider,Database.EventsDbContext context, IMapper mapper, GalerijaServiceImpl gallery) : base(serviceProvider, context, mapper)
        {
            _gallery = gallery;
        }

        public override async Task<Dogadjaji> Insert(DogadjajiInsertRequest request)
        {
            var set = _context.Set<Database.Dogadjaji>();

            var entity = _mapper.Map<Database.Dogadjaji>(request);
            entity.Status = "DRAFT";

            set.Add(entity);
           // await BeforeInsert(entity, insert);
            await _context.SaveChangesAsync();
            if (request.Galerija?.Count > 0)
            {
                await _gallery.InsertGallery(entity.DogadjajId, request.Galerija);
            }

            return _mapper.Map<Dogadjaji>(entity);
        }


        public override List<string> AllowedActions(Database.Dogadjaji entity)
        {
            /*var list=await base.AllowedActions();
            list.Add("Verify");
            list.Add("Cancel");*/

            return new List<string>() { nameof(Insert)};
        }
    }
}
