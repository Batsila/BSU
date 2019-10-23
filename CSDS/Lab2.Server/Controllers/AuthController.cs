using Lab2.Server.Models;
using Lab2.Server.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Lab2.Server.Controllers
{
    [AllowAnonymous]
    [Route("api/")]
    public class AuthController : Controller
    {
        private IClientService _clientService;

        public AuthController(IClientService clientService)
        {
            _clientService = clientService;
        }

        [HttpPost("auth")]
        public IActionResult Auth([FromBody]AuthRequest authRequests)
        {
            var response = _clientService.Authenticate(authRequests);

            if (response == null)
                return BadRequest();

            return Ok(response);
        }

    }
}
