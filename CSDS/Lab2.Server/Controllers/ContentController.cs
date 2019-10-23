using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Lab2.Server.Controllers
{
    [Authorize]
    [Route("api/content")]
    public class ContentController : Controller
    {
        [HttpGet]
        public IActionResult Get()
        {
            return Ok("Test Content.");
        }
    }
}
