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
    public class GalerijaController : BaseController<Slike, Slike, GalerijaSearchObject>
    {
        IGalerijaService galerijaService;
        public GalerijaController(ILogger<BaseController<Model.Slike, Model.Slike, GalerijaSearchObject>> logger, IGalerijaService service) : base(logger, service)
        {
            this.galerijaService = service;
        }

        [HttpDelete("{id}")]
        public virtual async Task<Model.Slike> Delete(int id)
        {
            return await galerijaService.Delete(id);
        }
    }
}
