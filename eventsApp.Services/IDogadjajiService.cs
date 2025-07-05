using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eventsApp.Model;
using eventsApp.Model.Messages;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Services
{
    public interface IDogadjajiService:ICRUDService<Model.DogadjajiListResponse, Model.Dogadjaji, DogadjajiSearchObject,Model.Requests.DogadjajiInsertRequest, Model.Requests.DogadjajiUpdateRequest>
    {
        Task<Dogadjaji> Activate(int id);

        Task<Dogadjaji> Hide(int id);

        Task<Dogadjaji> Verify(int id);

        Task<Dogadjaji> SendRequestForTickets(int id, List<KarteRequest> request);

        Task<List<string>> AllowedActions(int id);

        public Task<List<Model.DogadjajiListResponse>> GetEventsFromFollowingCategories(int korisnikId);

        public Task<Model.PagedResult<DogadjajiListResponse>> FindVerified(BaseSearchObject? search);

        public Task<HttpResponseMessage> LoadTickets(KarteDobavljacResponseList karteList);

        public Task<DogadjajiReportResponse> GetReportData(DogadjajiReportSearchObject? search);

        public Task<List<DogadjajiListResponse>> GetMostPopularEvents();
    }
}
