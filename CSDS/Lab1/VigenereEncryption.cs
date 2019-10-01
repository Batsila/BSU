using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1
{
    /// <summary>
    /// The class that implements Vigenere encryption 
    /// </summary>
    public class VigenereEncryption
    {
        public const string ENG_ALPHABET = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
        public const string RUS_ALPHABET = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";

        private readonly string _alphabet;

        public VigenereEncryption(string alphabet = ENG_ALPHABET)
        {
            _alphabet = alphabet;
        }

        public string Encrypt(string text, string key) => DoVigenereCipher(text, key, true);

        public string Decrypt(string text, string key) => DoVigenereCipher(text, key, false);

        private string DoVigenereCipher(string text, string key, bool isEncrypt)
        {
            var gamma = RepeatKey(key, text.Length);

            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < text.Length; ++i)
            {
                var textIndex = _alphabet.IndexOf(text[i]);
                var gammaIndex = _alphabet.IndexOf(gamma[i]);

                if (textIndex < 0)
                {
                    sb.Append(text[i].ToString());
                }
                else
                {
                    var index = (_alphabet.Length + textIndex + gammaIndex * 
                        (isEncrypt ? 1 : -1)) % _alphabet.Length;
                    sb.Append(_alphabet[index]);
                }
            }

            return sb.ToString();
        }

        private string RepeatKey(string key, int length)
        {
            StringBuilder sb = new StringBuilder(key);

            while (sb.Length < length)
                sb.Append(key);

            return sb.ToString();
        }
    }
}
