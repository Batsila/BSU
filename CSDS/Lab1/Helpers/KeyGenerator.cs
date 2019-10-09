using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1.Helpers
{
    public class KeyGenerator
    {
        private readonly string _alphabet;
        private readonly Random _rand;

        public KeyGenerator(string alphabet)
        {
            _alphabet = alphabet;
            _rand = new Random();
        }

        public string GetKey(int length)
        {
            var sb = new StringBuilder();
            for (var i = 0; i < length; ++i)
                sb.Append(GetSymbol());

            return sb.ToString();
        }

        private char GetSymbol()
        {
            var index = _rand.Next(0, _alphabet.Length - 1);

            return _alphabet[index];
        }
    }
}
