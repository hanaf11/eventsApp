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
    public class DogadjajiController : BaseCRUDController<Model.Dogadjaji, Model.SearchObjects.DogadjajiSearchObject, Model.Requests.DogadjajiInsertRequest, Model.Requests.DogadjajiUpdateRequest>
    {
        public DogadjajiController(ILogger<BaseController<Dogadjaji, DogadjajiSearchObject>> logger, IDogadjajiService service) : base(logger, service)
        {
        }
    }
}
