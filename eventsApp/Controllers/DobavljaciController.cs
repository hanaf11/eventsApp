using eventsApp.Model;
using eventsApp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]

    public class DobavljaciController : BaseController<Model.Dobavljaci, Model.SearchObjects.DobavljaciSearchObject>
    {
        public DobavljaciController(ILogger<BaseController<Dobavljaci,Model.SearchObjects.DobavljaciSearchObject>> logger, IDobavljaciService service) : base(logger, service)
        {
        }
    }
}
