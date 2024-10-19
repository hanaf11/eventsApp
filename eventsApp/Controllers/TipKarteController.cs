using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]

    public class TipKarteController : BaseController<Model.TipKarte, Model.TipKarte, Model.SearchObjects.TipKarteSearchObject>
    {
        public TipKarteController(ILogger<BaseController<TipKarte, Model.TipKarte, Model.SearchObjects.TipKarteSearchObject>> logger, ITipKarteService service) : base(logger, service)
        {
        }

     
    }
}
