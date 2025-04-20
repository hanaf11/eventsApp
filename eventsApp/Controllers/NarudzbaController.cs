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
    public class NarudzbaController : BaseController<Model.Narudzbe, Model.Narudzbe, NarudzbaSearchObject>
    {
        public NarudzbaController(ILogger<NarudzbaController> logger, INarudzbaService service):base(logger,service)
        {
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

        [HttpGet("narudzbe-by-korisnik")]
        public async Task<List<Model.Dogadjaji>> GetNarudzbeDogadjaji([FromQuery]NarudzbaDogaadjajSearchObject? search=null)
        {
            return await (_service as INarudzbaService).GetNarudzbeDogadjaji(search);
        }

        [HttpGet("report")]
        public virtual async Task<NarudzbeReportResponse> GetReportData([FromQuery] NarudzbeReportSearchObject? search = null)
        {
            return await (_service as INarudzbaService).GetReportData(search);
        }

    }
}
