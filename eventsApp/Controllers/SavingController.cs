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
    public class SavingController : ControllerBase
    {
        protected readonly ISavingService _service;
        protected readonly ILogger<SavingController> _logger;

        public SavingController(ILogger<SavingController> logger, ISavingService service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet("is-saved")]
        public async Task<bool> Get([FromQuery] SavingObject? search = null)
        {
            return await _service.IsSaved(search);
        }

        [HttpPost]
        public async Task<bool> Save([FromBody] SavingObject insert)
        {
            return await _service.Save(insert);
        }

        [HttpDelete()]
        public async Task<bool> Delete([FromBody] SavingObject request)
        {
            return await _service.Delete(request);
        }

        [HttpGet("{korisnikId}/saved")]
        public async Task<List<Model.DogadjajiListResponse>> GetSavedEvents(int korisnikId)
        {
            return await _service.GetSavedEvents(korisnikId);
        }
    }
}
