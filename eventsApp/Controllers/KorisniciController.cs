using eventsApp.Model.Requests;
using eventsApp.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : BaseCRUDController<Model.KorisniciListResponse, Model.Korisnici, Model.SearchObjects.KorisniciSearchObject, Model.Requests.KorisniciInsertRequest, Model.Requests.KorisniciUpdateRequest>
    {
        public KorisniciController(ILogger<BaseController<Model.KorisniciListResponse, Model.Korisnici, Model.SearchObjects.KorisniciSearchObject>> logger, IKorisniciService service):base(logger,service)
        {
        }

        [HttpPost("login")]
        [AllowAnonymous]
        public Task<Model.Korisnici> login(string username, string password)
        {
            return (_service as IKorisniciService).Login(username, password);
        }

    }
}
