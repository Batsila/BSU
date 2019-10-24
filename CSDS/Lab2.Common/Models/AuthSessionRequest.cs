using System.ComponentModel.DataAnnotations;

namespace Lab2.Common.Models
{
    public class AuthSessionRequest
    {
        [Required]
        public string Login { get; set; }
    }
}
