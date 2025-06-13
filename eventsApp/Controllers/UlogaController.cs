using eventsApp.Model;
using eventsApp.Model.SearchObjects;
using eventsApp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class UlogaController : BaseController<Uloge, Uloge, UlogaSearchObject>
    {
        IUlogaService _ulogaService;
        public UlogaController(ILogger<BaseController<Model.Uloge, Model.Uloge, UlogaSearchObject>> logger, IUlogaService service) : base(logger, service)
        {
            _ulogaService = service;
        }
    }
}
