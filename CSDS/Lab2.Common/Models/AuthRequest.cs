using System.ComponentModel.DataAnnotations;

namespace Lab2.Common.Models
{
    public class AuthRequest
    {
        [Required]
        public string Login { get; set; }

        [Required]
        public string Password { get; set; }
    }
}
