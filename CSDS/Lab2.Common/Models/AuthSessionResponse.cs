using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace Lab2.Common.Models
{
    public class AuthSessionResponse
    {
        public string Login { get; set; }
        public PublicRSAParameters PublicRSAParameters { get; set; }
    }
}
