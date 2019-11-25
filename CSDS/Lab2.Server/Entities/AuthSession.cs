using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;

namespace Lab2.Server.Entities
{
    public class AuthSession
    {
        public string UserLogin { get; set; }
        public RSAParameters PriveteRSAParameters { get; set; }
        public string TelegramKey { get; set; }
    }
}
