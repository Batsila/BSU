using Lab1.Encryptions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1
{
    class Program
    {
        static void Main()
        {
            IEncryption ve = new VigenereEncryption(Alphabet.Eng);

            var key = "testkey";
            var encryptedText = ve.Encrypt(Text.Test, key);

            var vigenereBreaker = new VigenereBreaker(Alphabet.Eng, AlphabetFrequency.Eng);

            var guess = vigenereBreaker.BreakCipher(encryptedText);

            Console.WriteLine($"Key: {key}\nLength: {key.Length}\nGuess: {guess}");

            Console.ReadKey();
        }
    }
}
