using AutoMapper;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services.Database;
using eventsApp.Services.DogadjajiStateMachine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class DogadjajiServiceImpl : BaseCRUDService<Model.Dogadjaji, Database.Dogadjaji, DogadjajiSearchObject, Model.Requests.DogadjajiInsertRequest, Model.Requests.DogadjajiUpdateRequest>, IDogadjajiService
    {
        public BaseState _baseState { get; set; }
        public DogadjajiServiceImpl(BaseState baseState,EventsDbContext context, IMapper mapper) : base(context, mapper)
        {
            _baseState = baseState;
        }

        public override Task<Model.Dogadjaji> Insert(DogadjajiInsertRequest insert)
        {
            var state = _baseState.CreateState("Initial");
            return state.Insert(insert);
        }

        public override async Task<Model.Dogadjaji> Update(int id, DogadjajiUpdateRequest update)
        {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);
            return await state.Update(id, update);
        }

        public async Task<Model.Dogadjaji> Activate(int id)
        {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);
            return await state.Activate(id);
        }

        public async Task<Model.Dogadjaji> Cancel(int id)
        {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity.Status);
            return await state.Cancel(id);
        }

        public async Task<List<string>> AllowedActions(int id) {
            var entity = await _context.Dogadjajis.FindAsync(id);
            var state = _baseState.CreateState(entity?.Status);
            return await state.AllowedActions();
        }

    }
}
