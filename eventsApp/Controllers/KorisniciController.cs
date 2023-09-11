using eventsApp.Model.Requests;
using eventsApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : BaseCRUDController<Model.Korisnici, Model.Korisnici, Model.SearchObjects.KorisniciSearchObject, Model.Requests.KorisniciInsertRequest, Model.Requests.KorisniciUpdateRequest>
    {
        public KorisniciController(ILogger<BaseController<Model.Korisnici, Model.Korisnici, Model.SearchObjects.KorisniciSearchObject>> logger, IKorisniciService service):base(logger,service)
        {
        }

    }
}
