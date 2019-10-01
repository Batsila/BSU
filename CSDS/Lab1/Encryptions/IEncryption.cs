using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1.Encryptions
{
    public interface IEncryption
    {
        string Encrypt(string text, string key);

        string Decrypt(string text, string key);
    }
}
