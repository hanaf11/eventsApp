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
    //[AllowAnonymous]
    public class KategorijeController : BaseCRUDController<Model.Kategorije, Model.Kategorije, Model.SearchObjects.KategorijeSearchObject, Model.Requests.KategorijeInsertRequest, Model.Requests.KategorijeUpdateRequest>
    {
        public KategorijeController(ILogger<BaseController<Model.Kategorije, Model.Kategorije, KategorijeSearchObject>> logger, IKategorijeService service) : base(logger, service)
        {
        }

        [Authorize(Roles="Administrator")]
        public override Task<Kategorije> Insert([FromBody] KategorijeInsertRequest insert)
        {
            return base.Insert(insert);
        }
    }
}
