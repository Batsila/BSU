using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1
{
    class Program
    {
        static void Main(string[] args)
        {
            var ve = new VigenereEncryption();

            var enTest = ve.Encrypt("Small test text", "Key");

            Console.WriteLine(enTest);

            var deTest = ve.Decrypt(enTest, "Key");

            Console.WriteLine(deTest);
            Console.ReadKey();
        }
    }
}
