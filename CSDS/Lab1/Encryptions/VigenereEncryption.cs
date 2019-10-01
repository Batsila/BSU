using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1.Encryptions
{
    /// <summary>
    /// The class that implements Vigenere encryption 
    /// </summary>
    public class VigenereEncryption : IEncryption
    {
        private readonly string _alphabet;

        public VigenereEncryption(string alphabet)
        {
            if (string.IsNullOrEmpty(alphabet))
                throw new Exception("Missing argument.");

            _alphabet = alphabet;
        }

        public string Encrypt(string text, string key) => DoVigenereCipher(text, key, true);

        public string Decrypt(string text, string key) => DoVigenereCipher(text, key, false);

        private string DoVigenereCipher(string text, string key, bool isEncrypt)
        {
            if (text == null || key == null)
                throw new Exception("Missing argument.");

            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < text.Length; ++i)
            {
                var textIndex = _alphabet.IndexOf(char.ToUpper(text[i]));
                var keyIndex = _alphabet.IndexOf(char.ToUpper(key[i % key.Length]));

                if (textIndex < 0)
                {
                    sb.Append(text[i].ToString());
                }
                else
                {
                    var index = (_alphabet.Length + textIndex +  
                        (isEncrypt ? keyIndex : -keyIndex)) % _alphabet.Length;
                    sb.Append(char.IsLower(text[i]) ? 
                        char.ToLower(_alphabet[index]) : _alphabet[index]);
                }
            }

            return sb.ToString();
        }
    }
}
