using eventsApp.Model;
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
    public class BaseController<T,TDetails,TSearch> : ControllerBase where T : class where TDetails:class where TSearch: BaseSearchObject
    {
        protected readonly IService<T, TDetails, TSearch> _service;
        protected readonly ILogger<BaseController<T,TDetails, TSearch>> _logger;
            
        public BaseController(ILogger<BaseController<T,TDetails, TSearch>> logger, IService<T, TDetails, TSearch> service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpGet()]
        public virtual async Task<PagedResult<T>> Get([FromQuery]TSearch? search=null)
        {
            return await _service.Get(search);
        }

        [HttpGet("{id}")]
        public virtual async Task<TDetails> GetById(int id)
        {
            return await _service.GetById(id);
        }
    }
}

