using Lab2.Common.Models;

namespace Lab2.Server.Services
{
    public interface IClientService
    {
        AuthResponse Authenticate(AuthRequest authRequest);
    }
}
