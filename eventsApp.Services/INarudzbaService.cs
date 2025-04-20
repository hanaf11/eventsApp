using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface INarudzbaService : IService<Narudzbe, Narudzbe, NarudzbaSearchObject>
    {
        public Task<List<Model.ValidTipKarte>> ValidateRequest(Dictionary<int, int> request);
        public Task<Model.Narudzbe> CreateNarudzba(NarudzbaInsertRequest request);
        public Task<List<Model.Dogadjaji>> GetNarudzbeDogadjaji(NarudzbaDogaadjajSearchObject? search);
        public Task<List<Dictionary<string, object>>> GetMostOrdersUsers();

        public Task<NarudzbeReportResponse> GetReportData(NarudzbeReportSearchObject? search);
    }
}
