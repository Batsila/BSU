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

            var test = ve.Encrypt(Text.Test, "mouse");

            var vb = new VigenereBreaker(Alphabet.Eng, AlphabetFrequency.Eng);

            var t = vb.KasiskiTest(test);

            Console.ReadKey();
        }
    }
}
