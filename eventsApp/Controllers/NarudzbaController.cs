using eventsApp.Model.Requests;
using eventsApp.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class NarudzbaController : ControllerBase
    {
        protected readonly INarudzbaService _service;
        protected readonly ILogger<NarudzbaController> _logger;
        public NarudzbaController(ILogger<NarudzbaController> logger, INarudzbaService service)
        {
            _service = service;
            _logger = logger;
        }

        [HttpPost("validate-request")]
        public async Task<List<Model.ValidTipKarte>> ValidateRequest([FromBody]Dictionary<string,int> request)
        {
            var convertedQuantities = request.ToDictionary(
                 kvp => int.Parse(kvp.Key),
                 kvp => kvp.Value
            );
            return await (_service as INarudzbaService).ValidateRequest(convertedQuantities);
        }

        [HttpPost]
        public async Task<Model.Narudzbe> CreateNarudzba([FromBody] NarudzbaInsertRequest request)
        {
            return await (_service as INarudzbaService).CreateNarudzba(request);
        }
    }
}
