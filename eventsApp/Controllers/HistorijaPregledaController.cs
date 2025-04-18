using eventsApp.Model;
using eventsApp.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class HistorijaPregledaController : ControllerBase
    {
        protected readonly IHistorijaPregledaService _service;
        protected readonly ILogger<HistorijaPregledaController> _logger;

        public HistorijaPregledaController(ILogger<HistorijaPregledaController> logger, IHistorijaPregledaService service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet]
        public async Task<List<Dogadjaji>> Get(int korisnikId)
        {
            return await _service.GetByKorisnikId(korisnikId);
        }
    }
}
