using System.ComponentModel.DataAnnotations;
using System.Security.Cryptography;

namespace Lab2.Common.Models
{
    public class AuthRequest
    {
        [Required]
        public string Login { get; set; }

        [Required]
        public byte[] EncryptedPassword { get; set; }

        [Required]
        public byte[] EncryptedTelegramKey { get; set; }

        [Required]
        public PublicRSAParameters ClientPublicRSAParameters { get; set; }
    }
}
