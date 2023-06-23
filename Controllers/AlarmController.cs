using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WeWakeAPI.Controllers
{
    [Route("api/Alarm")]
    [ApiController]
    public class AlarmController : ControllerBase
    {
        [HttpPost("/Set")]
        public async Task<ActionResult> SetAlarm()
        {
            return Ok();
        }
    }
}
