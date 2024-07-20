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
    [Authorize]
    public class KomentariController : BaseController<Komentari, Komentari, KomentarSearchObject>
    {

        public KomentariController(ILogger<KomentariController> logger, IKomentariService service):base(logger,service)
        {
        }


        [HttpPost]
        public async Task<PagedResult<Model.Komentari>> Post(KomentarInsertObject insert)
        {
            return await (_service as IKomentariService).Post(insert);
        }

       
    }
}
