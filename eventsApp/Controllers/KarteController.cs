using eventsApp.Model;
using eventsApp.Model.SearchObjects;
using eventsApp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KarteController : BaseController<Karta, Karta, KarteSearchObject>
    {
        IKarteService _karteService;
        public KarteController(ILogger<BaseController<Model.Karta, Model.Karta, KarteSearchObject>> logger, IKarteService service) : base(logger, service)
        {
           _karteService = service;
        }
    }
}
