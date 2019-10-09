using Lab1.Encryptions;
using Lab1.Helpers;
using System;
using System.IO;

namespace Lab1
{
    class Program
    {
        static readonly int N = 100;
        static readonly int[] TEXT_LENGTHS = { 250, 500, 1000, 2000 };
        static readonly int[] KEY_LENGTHS = { 4, 8, 12, 16, 20 };
        static TextGenerator _textGenerator;
        static KeyGenerator _keyGenerator;
        static VigenereEncryption _vigenereEncryption;
        static VigenereBreaker _vigenereBreaker;

        static void Main()
        {
            _textGenerator = new TextGenerator();
            _keyGenerator = new KeyGenerator(Alphabet.Eng);
            _vigenereEncryption = new VigenereEncryption(Alphabet.Eng);
            _vigenereBreaker = new VigenereBreaker(Alphabet.Eng, AlphabetFrequency.Eng);

            using (StreamWriter streamWriter = new StreamWriter("text.csv"))
            {
                ExperimentTextLength(streamWriter);
            }

            using (StreamWriter streamWriter = new StreamWriter("key.csv"))
            {
                ExperimentKeyLength(streamWriter);
            }

            Console.WriteLine("Done.");
            Console.ReadKey();
        }

        static void ExperimentTextLength(StreamWriter streamWriter)
        {
            streamWriter.WriteLine("KeyLength;TextLength;Probability");
            foreach (var keyLength in KEY_LENGTHS)
            {
                var key = _keyGenerator.GetKey(keyLength);

                for (int i = 250; i <= 3000; i += 250)
                {
                    var correct = 0.0;

                    for (int j = 0; j < N; ++j)
                    {
                        var text = _textGenerator.GetText(i);

                        var encryptedText = _vigenereEncryption.Encrypt(text, key);
                        var guess = _vigenereBreaker.BreakCipher(encryptedText);

                        if (guess.ToUpper() == key.ToUpper())
                            ++correct;
                    }

                    streamWriter.WriteLine($"{keyLength};{i};{correct / N}");
                }

            }
        }

        static void ExperimentKeyLength(StreamWriter streamWriter)
        {
            streamWriter.WriteLine("TextLength;KeyLength;Probability");
            foreach (var textLength in TEXT_LENGTHS)
            {
                var text = _textGenerator.GetText(textLength);

                for (int i = 1; i <= 20; ++i)
                {
                    var correct = 0.0;

                    for (int j = 0; j < N; ++j)
                    {
                        var key = _keyGenerator.GetKey(i);

                        var encryptedText = _vigenereEncryption.Encrypt(text, key);
                        var guess = _vigenereBreaker.BreakCipher(encryptedText);

                        if (guess.ToUpper() == key.ToUpper())
                            ++correct;
                    }

                    streamWriter.WriteLine($"{textLength};{i};{correct / N}");
                }

            }
        }
    }
}
