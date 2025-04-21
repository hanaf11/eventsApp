using AutoMapper;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class StavkaNarudzbeServiceImpl
    {
        protected EventsDbContext _context;
        protected IMapper _mapper;
        public StavkaNarudzbeServiceImpl(EventsDbContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }


    }
}
