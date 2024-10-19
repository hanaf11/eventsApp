using eventsApp.Model;
using eventsApp.Model.Messages;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class DogadjajiController : BaseCRUDController<Model.DogadjajiListResponse, Model.Dogadjaji, Model.SearchObjects.DogadjajiSearchObject, Model.Requests.DogadjajiInsertRequest, Model.Requests.DogadjajiUpdateRequest>
    {
        public DogadjajiController(ILogger<BaseController<DogadjajiListResponse, Dogadjaji, DogadjajiSearchObject>> logger, IDogadjajiService service) : base(logger, service)
        {
        }

        [HttpPut("{id}/activate")]
        public virtual async Task<Model.Dogadjaji> Activate(int id)
        {
            return await (_service as IDogadjajiService).Activate(id);
        }


        [HttpPut("{id}/hide")]
        public virtual async Task<Model.Dogadjaji> Hide(int id)
        {
            return await (_service as IDogadjajiService).Hide(id);
        }


        [HttpPut("{id}/verify")]
        public virtual async Task<Model.Dogadjaji> Verify(int id)
        {
            return await (_service as IDogadjajiService).Verify(id);
        }

        [HttpPut("{id}/send-ticket-request")]
        public virtual async Task<Model.Dogadjaji> SendRequestForTickets(int id, [FromBody] List<KarteRequest> request)
        {
             return await (_service as IDogadjajiService).SendRequestForTickets(id,request);
        }

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IDogadjajiService).AllowedActions(id);
        }

        [HttpGet("{korisnikId}/following-categories")]
        public async Task<List<Model.DogadjajiListResponse>> GetEventsFromFollowingCategories(int korisnikId)
        {
            return await (_service as IDogadjajiService).GetEventsFromFollowingCategories(korisnikId);
        }

        [HttpGet("find-verified")]
        public async Task<Model.PagedResult<DogadjajiListResponse>> FindVerified([FromQuery] BaseSearchObject? search = null)
        {
            return await (_service as IDogadjajiService).FindVerified(search);
        }

        [HttpPost("send-tickets")]
        public async Task<HttpResponseMessage> LoadTickets([FromBody]KarteDobavljacResponseList karteList)
        {
            return await (_service as IDogadjajiService).LoadTickets(karteList);
        }

        /* [HttpGet("{id}/recommend")]
         public virtual List<Model.Dogadjaji> Recommend(int id)
         {
             return  (_service as IDogadjajiService).Recommend(id);
         }*/

    }
}
