using eventsApp.Model;
using eventsApp.Model.SearchObjects;
using eventsApp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    public class KategorijeController : BaseController<Model.Kategorije, BaseSearchObject>
    {
        public KategorijeController(ILogger<BaseController<Model.Kategorije, BaseSearchObject>> logger, IService<Model.Kategorije, BaseSearchObject> service) : base(logger, service)
        {
        }
    }
}
