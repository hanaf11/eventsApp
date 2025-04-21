using eventsApp.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class StavkeNarudzbeController : ControllerBase
    {
        protected readonly INarudzbaStavkeService _service;
        protected readonly ILogger<StavkeNarudzbeController> _logger;

        public StavkeNarudzbeController(ILogger<StavkeNarudzbeController> logger, INarudzbaStavkeService service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet]
        public async Task<List<Model.StavkeNarudzbe>> Get(int narudzbaId)
        {
            return await (_service as INarudzbaStavkeService).Get(narudzbaId);
        }
    }
}
