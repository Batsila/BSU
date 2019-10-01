using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1
{
    public class VigenereBreaker
    {
        private readonly string _alphabet;
        private readonly double[] _frequencies;

        public VigenereBreaker(string alphabet, double[] frequencies)
        {
            if (alphabet == null || frequencies == null)
                throw new Exception("Missing argument.");

            if (alphabet.Length != frequencies.Length)
                throw new Exception("Incorrect arguments.");

            _alphabet = alphabet;
            _frequencies = frequencies;
        }

        public IEnumerable<int> KasiskiTest(string text)
        {
            var distances = GetDistances(text);
            return new List<int>();
        }

        private IEnumerable<int> GetDistances(string text)
        {
            var distances = new List<int>();

            var i = 0;
            while (i <= text.Length - 3)
            {
                var j = i + 1;
                var subLength = 3;
                while (j < text.Length - subLength)
                {
                    if (text.Substring(i, subLength) == text.Substring(j, subLength))
                    {
                        while (text.Substring(i, subLength + 1) == text.Substring(j, subLength + 1))
                            ++subLength;
                        distances.Add(j - i);

                        j += subLength;
                    }
                    ++j;
                }
                i += subLength - 2;
            }

            return distances;
        }
    }
}
