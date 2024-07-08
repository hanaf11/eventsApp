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
    public class PracenjeController : ControllerBase
    {
        protected readonly IPracenjeService _service;
        protected readonly ILogger<PracenjeController> _logger;

        public PracenjeController(ILogger<PracenjeController> logger, IPracenjeService service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet("is-following")]
        public async Task<bool> Get([FromQuery] PracenjeObject? search = null)
        {
            return await _service.IsFollowing(search);
        }

        [HttpPost]
        public async Task<bool> Follow([FromBody] PracenjeObject insert)
        {
            return await _service.Follow(insert);
        }

        [HttpDelete()]
        public async Task<bool> Unfollow([FromBody] PracenjeObject request)
        {
            return await _service.Unfollow(request);
        }
    }
}
