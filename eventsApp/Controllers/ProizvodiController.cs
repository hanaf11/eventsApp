using eventsApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace eventsApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodiController:ControllerBase
    {
        private readonly IDobavljaciService _dobavljaciService;
        public ProizvodiController(IDobavljaciService dobavljaciService)
        {
            _dobavljaciService = dobavljaciService;
        }

      /*  [HttpGet]
        public IEnumerable<Dobavljaci> Get()
        {
            
            return _dobavljaciService.Get();
        }*/

       /* [HttpGet("{id}")]
        public Dobavljaci GetById(int id)
        {

            return _dobavljaciService.GetById(id);
        }*/
    }
}
