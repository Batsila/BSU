using Lab2.Common.Models;
using Lab2.Common.Security;
using Lab2.Server.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Linq;
using System.Security.Claims;
using System.Text;

namespace Lab2.Server.Controllers
{
    [Authorize]
    [Route("api/content")]
    public class ContentController : Controller
    {
        private readonly string _chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

        private readonly IAuthService _authService;

        public ContentController(IAuthService authService)
        {
            _authService = authService;
        }

        [HttpPost]
        public IActionResult Get([FromBody]byte[] request)
        {
            var userLoginClaim = User.Claims.SingleOrDefault(x => x.Type == ClaimTypes.Name);

            if (userLoginClaim == null)
                return BadRequest("Invalid token");
            var t = _authService.SessionData.SingleOrDefault(x => x.Item1 == userLoginClaim.Value);

            var sessionKey = t.Item2;
            var sessionIV = t.Item3;

            var requestStr = AES.DecryptStringFromBytes_Aes(request, sessionKey, sessionIV);

            var contentWeb = JsonConvert.DeserializeObject<ContentWeb>(requestStr);

            if (contentWeb.Garbage != t.Item4)
                return BadRequest();

            t.Item4 = UpdateGarbage();
            _authService.SessionData.RemoveAll(x => x.Item1 == t.Item1);
            _authService.SessionData.Add(t);
            contentWeb.Garbage = t.Item4;
            contentWeb.Data = _authService.Content;

            var responseStr = JsonConvert.SerializeObject(contentWeb);

            var encryptedResponse = AES.EncryptStringToBytes_Aes(responseStr, sessionKey, sessionIV);

            return Ok(new ContentResponse(encryptedResponse));
        }

        [HttpPatch]
        public IActionResult Save([FromBody]byte[] request)
        {
            var userLoginClaim = User.Claims.SingleOrDefault(x => x.Type == ClaimTypes.Name);

            if (userLoginClaim == null)
                return BadRequest("Invalid token");

            var t = _authService.SessionData.SingleOrDefault(x => x.Item1 == userLoginClaim.Value);

            var sessionKey = t.Item2;
            var sessionIV = t.Item3;

            var requestStr = AES.DecryptStringFromBytes_Aes(request, sessionKey, sessionIV);

            var contentWeb = JsonConvert.DeserializeObject<ContentWeb>(requestStr);

            if (contentWeb.Garbage != t.Item4)
                return BadRequest();

            _authService.Content = contentWeb.Data;

            t.Item4 = UpdateGarbage();
            _authService.SessionData.RemoveAll(x => x.Item1 == t.Item1);
            _authService.SessionData.Add(t);
            contentWeb.Garbage = t.Item4;

            var responseStr = JsonConvert.SerializeObject(contentWeb);

            var encryptedResponse = AES.EncryptStringToBytes_Aes(responseStr, sessionKey, sessionIV);

            return Ok(new ContentResponse(encryptedResponse));
        }

        private string UpdateGarbage()
        {
            var sb = new StringBuilder();
            var random = new Random();

            for (var i = 0; i < 27; ++i)
                sb.Append(_chars[random.Next(_chars.Length)]);

            return sb.ToString();
        }
    }
}
