using Lab2.Server.Entities;
using Lab2.Server.Helpers;
using Lab2.Server.Models;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;

namespace Lab2.Server.Services
{
    public class ClientService : IClientService
    {
        private readonly List<Client> _clints = new List<Client>
        {
            new Client { Id = 1, Login = "TestLogin", Password = "TestPassword" }
        };

        private readonly AppSettings _appSettings;

        public ClientService(IOptions<AppSettings> appSettings)
        {
            _appSettings = appSettings.Value;
        }

        public AuthResponse Authenticate(AuthRequest authRequest)
        {
            var client = _clints.SingleOrDefault(x => x.Login == authRequest.Login && x.Password == authRequest.Password);

            if (client == null)
                return null;

            var authResponse = new AuthResponse
            {
                Login = client.Login
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_appSettings.TokenKey);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, authResponse.Login)
                }),
                Expires = DateTime.UtcNow.AddMinutes(1),
                NotBefore = DateTime.UtcNow,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);

            authResponse.Token = tokenHandler.WriteToken(token);

            return authResponse;
        }
    }
}
