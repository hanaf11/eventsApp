using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]

    public class DobavljaciController : BaseCRUDController<Model.Dobavljaci, Model.Dobavljaci, Model.SearchObjects.DobavljaciSearchObject, DobavljaciInsertRequest, DobavljaciUpdateRequest>
    {
        public DobavljaciController(ILogger<BaseController<Dobavljaci, Model.Dobavljaci, Model.SearchObjects.DobavljaciSearchObject>> logger, IDobavljaciService service) : base(logger, service)
        {
        }

        [HttpPut("{id}/change-status")]
        public virtual async Task<Model.Dobavljaci> ChangeStatus(int id, [FromBody] bool status)
        {
            return await (_service as IDobavljaciService).ChangeStatus(id,status);
        }
    }
}
