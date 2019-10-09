using Lab1.Encryptions;
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
        private readonly VigenereEncryption _vigenereEncryption;

        public VigenereBreaker(string alphabet, double[] frequencies)
        {
            if (alphabet == null || frequencies == null)
                throw new Exception("Missing argument.");

            if (alphabet.Length != frequencies.Length)
                throw new Exception("Incorrect arguments.");

            _alphabet = alphabet;
            _frequencies = frequencies;

            _vigenereEncryption = new VigenereEncryption(alphabet);
        }

        public string BreakCipher(string text)
        {
            var lengths = KasiskiTest(text);

            var res = new List<KeyValuePair<string, double>>();

            foreach (var length in lengths)
            {
                res.Add(FrequenciesAnalysis(text, length.Key));
            }

            return res.OrderBy(x => x.Value).Select(x => x.Key).First();
        }

        public IEnumerable<KeyValuePair<int, double>> KasiskiTest(string text, int take = 3)
        {
            var distances = GetDistances(text)
                .OrderByDescending(x => x.Value)
                .ToList();

            var dividers = GetDividers(distances);

            double sum = 0;

            foreach (var divider in dividers)
            {
                sum += divider.Value;
            }

            var ans = new List<KeyValuePair<int, double>>();

            foreach (var divider in dividers.OrderByDescending(x => x.Value).Take(take))
            {
                ans.Add(new KeyValuePair<int, double>(divider.Key, divider.Value / sum));
            }

            return ans;
        }

        public KeyValuePair<string, double> FrequenciesAnalysis(string text, int keyLength)
        {
            var subTexts = GetSubTexts(text, keyLength);

            var sb = new StringBuilder();
            var rate = 0.0;

            foreach (var subText in subTexts)
            {
                var guess = FrequenciesAnalysis(subText);
                sb.Append(guess.Key);
                rate += guess.Value;
            }

            rate /= keyLength;

            return new KeyValuePair<string, double>(sb.ToString(), rate);
        }

        private KeyValuePair<string, double> FrequenciesAnalysis(string text)
        {
            double rate = double.MaxValue;
            var ans = string.Empty;

            foreach (var l in _alphabet)
            {
                var decryptText = _vigenereEncryption.Decrypt(text, l.ToString());
                var frequencies = GetFrequencies(decryptText);
                var currentRate = RateFrequencies(frequencies);

                if (currentRate < rate)
                {
                    ans = l.ToString();
                    rate = currentRate;
                }
            }

            return new KeyValuePair<string, double>(ans, rate);
        }

        private double RateFrequencies(double[] frequencies)
        {
            var rate = 0.0;

            for (int i = 0; i < frequencies.Length; ++i)
            {
                rate += Math.Abs(frequencies[i] - _frequencies[i]);
            }

            return rate;
        }

        private double[] GetFrequencies(string text)
        {
            double[] frequencies = new double[_alphabet.Length];

            foreach (var s in text)
            {
                var index = _alphabet.IndexOf(char.ToUpper(s));

                if (index >= 0)
                {
                    ++frequencies[index];
                }
            }

            for (int i = 0; i < frequencies.Length; ++i)
            {
                frequencies[i] /= text.Length;
            }

            return frequencies;
        }

        private List<string> GetSubTexts(string text, int keyLength)
        {
            var subTexts = new List<string>();

            for (int i = 0; i < keyLength; ++i)
            {
                var sb = new StringBuilder();

                for (int j = i; j < text.Length; j += keyLength)
                {
                    sb.Append(text[j]);
                }

                subTexts.Add(sb.ToString());
            }

            return subTexts;
        }

        private Dictionary<int, int> GetDividers(List<KeyValuePair<int, int>> distances)
        {
            var dividers = new Dictionary<int, int>();

            for (int i = 0; i < distances.Count - 1; ++i)
            {
                for (int j = i + 1; j < distances.Count; ++j)
                {
                    var divider = GCD(distances[i].Key, distances[j].Key);

                    var score = (distances[i].Value + distances[j].Value) / 2;

                    if (dividers.ContainsKey(divider))
                        dividers[divider] += score;
                    else
                        dividers.Add(divider, score);
                }
            }

            return dividers;
        }

        private List<KeyValuePair<int, int>> GetDistances(string text)
        {
            var distances = new List<KeyValuePair<int, int>>();

            var i = 0;
            while (i <= text.Length - 3)
            {
                var j = i + 2;
                var subLength = 3;
                while (j < text.Length - subLength)
                {
                    if (text.Substring(i, subLength) == text.Substring(j, subLength))
                    {
                        while (text.Substring(i, subLength + 1) == text.Substring(j, subLength + 1))
                            ++subLength;
                        distances.Add(new KeyValuePair<int, int>(j - i, subLength));

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
