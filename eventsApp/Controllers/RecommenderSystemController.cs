using eventsApp.Model;
using eventsApp.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class RecommenderSystemController : ControllerBase
    {
        private readonly IRecommenderSystemService _service;
        public RecommenderSystemController(IRecommenderSystemService service)
        {
           _service = service;
        }

        [HttpGet("{userId}")]
        public async Task<List<DogadjajiListResponse>> Recommend(int userId)
        {
            return await _service.Recommend(userId);
        }
    }
}
