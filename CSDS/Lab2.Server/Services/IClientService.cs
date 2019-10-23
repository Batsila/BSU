using Lab2.Server.Models;

namespace Lab2.Server.Services
{
    public interface IClientService
    {
        AuthResponse Authenticate(AuthRequest authRequest);
    }
}
