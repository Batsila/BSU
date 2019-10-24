using Lab2.Common.Models;

namespace Lab2.Server.Services
{
    public interface IAuthService
    {
        AuthSessionResponse CreateAuthSession(AuthSessionRequest authSessionRequest);
        AuthResponse Authenticate(AuthRequest authRequest);
    }
}
