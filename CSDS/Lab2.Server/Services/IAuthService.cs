using Lab2.Common.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Lab2.Server.Services
{
    public interface IAuthService
    {
        Task<AuthSessionResponse> CreateAuthSession(AuthSessionRequest authSessionRequest);
        AuthResponse Authenticate(AuthRequest authRequest);
        List<(string, byte[], byte[], string)> SessionData { get; set; }
        string Content { get; set; }
    }
}
