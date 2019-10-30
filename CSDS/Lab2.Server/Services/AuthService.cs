using Lab2.Common.Helpers;
using Lab2.Common.Models;
using Lab2.Server.Entities;
using Lab2.Server.Helpers;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Security.Principal;
using System.Text;

namespace Lab2.Server.Services
{
    public class AuthService : IAuthService
    {
        private readonly List<User> _users = new List<User>
        {
            new User { Login = "TestLogin", Password = "TestPassword" }
        };

        private readonly List<AuthSession> _authSessions = new List<AuthSession>();

        private readonly AppSettings _appSettings;

        public List<(string, byte[], byte[], string)> SessionData { get; set; }
        public string Content { get; set; }

        public AuthService(IOptions<AppSettings> appSettings)
        {
            _appSettings = appSettings.Value;
            SessionData = new List<(string, byte[], byte[], string)>();
            Content = "Here is some data to encrypt!";
        }

        public AuthSessionResponse CreateAuthSession(AuthSessionRequest authSessionRequest)
        {
            var user = _users.SingleOrDefault(x => x.Login == authSessionRequest.Login);

            if (user == null)
                return null;

            var authSessionResponse = new AuthSessionResponse
            {
                Login = user.Login
            };

            using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
            {
                authSessionResponse.PublicRSAParameters = RSA.ExportParameters(false).ToPublicRSAParameters();

                var existSession = _authSessions.SingleOrDefault(x => x.UserLogin == authSessionRequest.Login);
                if (existSession != null)
                {
                    _authSessions.Remove(existSession);
                }

                var authSession = new AuthSession
                {
                    UserLogin = user.Login,
                    PriveteRSAParameters = RSA.ExportParameters(true)
                };

                _authSessions.Add(authSession);
            }

            return authSessionResponse;
        }

        public AuthResponse Authenticate(AuthRequest authRequest)
        {
            var authSession = _authSessions.SingleOrDefault(x => x.UserLogin == authRequest.Login);

            if (authSession == null)
                return null;

            var pass = string.Empty;

            using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
            {
                RSA.ImportParameters(authSession.PriveteRSAParameters);
                var passBytes = RSA.Decrypt(authRequest.EncryptedPassword, false);
                pass = Encoding.Default.GetString(passBytes);
            }

            var user = _users.SingleOrDefault(x => x.Login == authRequest.Login && x.Password == pass);

            if (user == null)
                return null;

            byte[] sessionKey;
            byte[] sessionIV;

            using (AesCryptoServiceProvider Aes = new AesCryptoServiceProvider())
            {
                sessionKey = Aes.Key;
                sessionIV = Aes.IV;
            }

            SessionData.RemoveAll(x => x.Item1 == user.Login);
            var session = (user.Login, sessionKey, sessionIV, string.Empty);
            SessionData.Add(session);

            byte[] encryptedSessionKey;
            byte[] encryptedSessionIV;

            using (RSACryptoServiceProvider RSA = new RSACryptoServiceProvider())
            {
                RSA.ImportParameters(authRequest.ClientPublicRSAParameters.ToRSAParameters());
                encryptedSessionKey = RSA.Encrypt(sessionKey, false);
                encryptedSessionIV = RSA.Encrypt(sessionIV, false);
            }

            var token = CreateToken(user);

            var authResponse = new AuthResponse
            {
                Login = user.Login,
                Token = token,
                EncryptedSessionKey = encryptedSessionKey,
                EncryptedSessionIV = encryptedSessionIV
            };

            _authSessions.Remove(authSession);

            return authResponse;
        }

        private string CreateToken(User user)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_appSettings.TokenKey);

            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(
                new Claim[]
                {
                    new Claim(ClaimTypes.Name, user.Login)
                }),
                Expires = DateTime.UtcNow.AddMinutes(1),
                NotBefore = DateTime.UtcNow,
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);
        }
    }
}
