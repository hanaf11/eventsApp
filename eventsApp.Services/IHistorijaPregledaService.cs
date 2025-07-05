using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IHistorijaPregledaService
    {
        Task Create(int? korisnikId, int? dogadjajId);

        public Task<List<Model.Dogadjaji>> GetByKorisnikId(int korisnikId);

        Task<List<Dictionary<string, object>>> GetMostViewedEvents();
    }

}
