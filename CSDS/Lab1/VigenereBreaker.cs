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

        public int KasiskiTest(string text)
        {
            var distances = GetDistances(text);

            var dividers = GetDividers(distances);

            dividers.Remove(1);

            return dividers.OrderByDescending(x => x.Value).First().Key;
        }

        private Dictionary<int, int> GetDividers(List<int> distances)
        {
            var dividers = new Dictionary<int, int>();

            for (int i = 0; i < distances.Count - 1; ++i)
            {
                for (int j = i + 1; j < distances.Count; ++j)
                {
                    var divider = GCD(distances[i], distances[j]);

                    if (dividers.ContainsKey(divider))
                        dividers[divider] += 1;
                    else
                        dividers.Add(divider, 1);
                }
            }

            return dividers;
        }

        private List<int> GetDistances(string text)
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

        private int GCD(IEnumerable<int> numbers)
        {
            return numbers.Aggregate(GCD);
        }

        private int GCD(int a, int b)
        {
            return b == 0 ? a : GCD(b, a % b);
        }
    }
}
