using System;
using System.Text;

namespace Lab2.Server.Helpers
{
    public class KeyGenerator
    {
        private readonly string _alphabet = "QWERTY1234567890";
        private readonly Random _rand;

        public KeyGenerator()
        {
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
