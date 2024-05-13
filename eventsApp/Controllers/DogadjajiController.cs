using eventsApp.Model;
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

        [HttpGet("{id}/allowedActions")]
        public virtual async Task<List<string>> AllowedActions(int id)
        {
            return await (_service as IDogadjajiService).AllowedActions(id);
        }

       /* [HttpGet("{id}/recommend")]
        public virtual List<Model.Dogadjaji> Recommend(int id)
        {
            return  (_service as IDogadjajiService).Recommend(id);
        }*/
    }
}
