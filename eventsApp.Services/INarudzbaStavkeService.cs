using eventsApp.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface INarudzbaStavkeService
    {
        public Task<string> CreateNarudzbaStavke(List<ValidTipKarte> request, int narudzbaId);
        public Task<List<Dictionary<string, object>>> GetNumOfSoldTickets();

        public Task<List<Dictionary<string, object>>> GetMostSoldEvents();

        public Task<List<Model.StavkeNarudzbe>> Get(int narudzbaId);
    }
}
