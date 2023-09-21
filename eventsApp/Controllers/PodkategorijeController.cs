using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using eventsApp.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [AllowAnonymous]
    public class PodkategorijeController : BaseCRUDController<Model.Podkategorije, Model.Podkategorije, Model.SearchObjects.PodkategorijeSearchObject, Model.Requests.PodkategorijeCreateRequest, Model.Requests.PodkategorijeUpdateRequest>
    {
        public PodkategorijeController(ILogger<BaseController<Model.Podkategorije, Model.Podkategorije, PodkategorijeSearchObject>> logger, IPodkategorijeService service) : base(logger, service)
        {
        }

        [Authorize(Roles = "Administrator")]
        public override Task<Podkategorije> Insert([FromBody] PodkategorijeCreateRequest insert)
        {
            return base.Insert(insert);
        }
    }
}

