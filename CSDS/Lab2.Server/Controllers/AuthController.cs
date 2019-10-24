using Lab2.Common.Models;
using Lab2.Server.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Lab2.Server.Controllers
{
    [AllowAnonymous]
    [Route("api/")]
    public class AuthController : Controller
    {
        private readonly IAuthService _authService;

        public AuthController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost("session")]
        public IActionResult CreateAuthSession([FromBody]AuthSessionRequest authSessionRequest)
        {
            var response = _authService.CreateAuthSession(authSessionRequest);

            if (response == null)
                return BadRequest();

            return Ok(response);
        }

        [HttpPost("auth")]
        public IActionResult Auth([FromBody]AuthRequest authRequests)
        {
            var response = _authService.Authenticate(authRequests);

            if (response == null)
                return BadRequest();

            return Ok(response);
        }
    }
}
