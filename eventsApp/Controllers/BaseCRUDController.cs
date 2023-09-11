using eventsApp.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [Route("[controller]")]
    public class BaseCRUDController<T,TDetails,TSearch, TInsert, TUpdate> : BaseController<T, TDetails, TSearch> where T:class where TDetails:class where TSearch:class
    {
        protected new readonly ICRUDService<T, TDetails, TSearch, TInsert, TUpdate> _service;
        protected readonly ILogger<BaseController<T, TDetails, TSearch>> _logger;

        public BaseCRUDController(ILogger<BaseController<T, TDetails, TSearch>> logger, ICRUDService<T, TDetails, TSearch, TInsert, TUpdate> service):base(logger,service)
        {
            _logger = logger;
            _service = service;
        }

        [HttpPost]
        public virtual async Task<TDetails> Insert([FromBody]TInsert insert) {
            return await _service.Insert(insert);
        }

        [HttpPut("{id}")]
        public virtual async Task<TDetails> Update(int id, [FromBody]TUpdate update) {
            return await _service.Update(id, update);
        }

        [HttpDelete("{id}")]
        public virtual async Task<TDetails> Delete(int id)
        {
            return await _service.Delete(id);
        }
    }
}
