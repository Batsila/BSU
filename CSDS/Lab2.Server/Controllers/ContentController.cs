using Lab2.Common.Models;
using Lab2.Common.Security;
using Lab2.Server.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Linq;
using System.Security.Claims;
using System.Text;

namespace Lab2.Server.Controllers
{
    [Authorize]
    [Route("api/content")]
    public class ContentController : Controller
    {
        private readonly string text = "Here is some data to encrypt!";

        private readonly IAuthService _authService;

        public ContentController(IAuthService authService)
        {
            _authService = authService;
        }
        [HttpGet]
        public IActionResult Get()
        {
            var userLoginClaim = User.Claims.SingleOrDefault(x => x.Type == ClaimTypes.Name);

            if (userLoginClaim == null)
                return BadRequest("Invalid token");

            var t = _authService.SessionData.SingleOrDefault(x => x.Item1 == userLoginClaim.Value);

            var sessionKey = t.Item2;
            var sessionIV = t.Item3;

            var encryptedText = AES.EncryptStringToBytes_Aes(text, sessionKey, sessionIV);

            var contentResponse = new ContentResponse
            {
                EncryptedText = encryptedText
            };

            return Ok(contentResponse);
        }
    }
}
