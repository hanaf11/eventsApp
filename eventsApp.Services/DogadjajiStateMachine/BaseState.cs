using AutoMapper;
using eventsApp.Model.Requests;
using eventsApp.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.DogadjajiStateMachine
{
    public class BaseState
    {
        protected EventsDbContext _context;
        protected IMapper _mapper { get; set; }

        public BaseState(EventsDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }
        public virtual Task<Model.Dogadjaji> Insert(DogadjajiInsertRequest request)
        {
            throw new Exception("Not allowed");
        }
        public virtual Task<Model.Dogadjaji> Update(int id, DogadjajiUpdateRequest request)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.Dogadjaji> Activate(int id)
        {
            throw new Exception("Not allowed");
        }

        public virtual Task<Model.Dogadjaji> Cancel(int id)
        {
            throw new Exception("Not allowed");
        }
    }
}

