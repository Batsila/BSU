namespace Lab2.Common.Models
{
    public class AuthResponse
    {
        public string Login { get; set; }

        public string Token { get; set; }

        public byte[] EncryptedSessionKey { get; set; }

        public byte[] EncryptedSessionIV { get; set; }
    }
}
