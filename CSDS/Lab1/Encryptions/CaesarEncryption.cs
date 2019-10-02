using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1.Encryptions
{
    public class CaesarEncryption : IEncryption
    {
        private readonly string _alphabet;

        public CaesarEncryption(string alphabet)
        {
            if (string.IsNullOrEmpty(alphabet))
                throw new Exception("Missing argument.");

            _alphabet = alphabet;
        }

        public string Decrypt(string text, string key) => DoCaesarCipher(text, key, false);

        public string Encrypt(string text, string key) => DoCaesarCipher(text, key, true);

        private string DoCaesarCipher(string text, string key, bool isEncrypt)
        {
            if (string.IsNullOrEmpty(text) || string.IsNullOrEmpty(key))
                throw new Exception("Missing argument.");

            if (key.Length != 1)
                throw new Exception("Caesar encryption required key length 1.");

            StringBuilder sb = new StringBuilder();

            int shift = _alphabet.IndexOf(key.ToUpper());

            foreach (var letter in text)
            {
                var letterIndex = _alphabet.IndexOf(char.ToUpper(letter));

                if (letterIndex < 0)
                {
                    sb.Append(letter);
                }
                else
                {
                    var index = (_alphabet.Length + letterIndex 
                        + (isEncrypt ? shift : -shift)) % _alphabet.Length;
                    sb.Append(char.IsLower(letter) ? 
                        char.ToLower(_alphabet[index]) : _alphabet[index]);
                }
            }

            return sb.ToString();
        }
    }
}
