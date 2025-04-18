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
    public interface IKorisniciService:ICRUDService<Model.KorisniciListResponse, Model.Korisnici, Model.SearchObjects.KorisniciSearchObject, Model.Requests.KorisniciInsertRequest, Model.Requests.KorisniciUpdateRequest>
    {
        public Task<Model.Korisnici> Login(string usernane, string password);

        public Task<KorisniciReportResponse> GetReportData(KorisniciReportSearchObject? search);

    }
}
