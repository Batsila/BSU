using Lab1.Encryptions;
using Lab1.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1
{
    class Program
    {
        static readonly int N = 100;
        static readonly int[] TEXT_LENGTHS = { 200, 500 };
        static readonly int[] KEY_LENGTHS = { 4, 8, 12 };
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

            ExperimentKeyLength();

            Console.ReadKey();
        }

        static void ExperimentTextLength()
        {
            foreach (var keyLength in KEY_LENGTHS)
            {
                var key = _keyGenerator.GetKey(keyLength);

                for (int i = 100; i < 500; i += 100)
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

                    Console.WriteLine($"Key: {key}, Text length {i}, Probability: {correct / N}.");
                }

            }
        }

        static void ExperimentKeyLength()
        {
            foreach (var textLength in TEXT_LENGTHS)
            {
                var text = _textGenerator.GetText(textLength);

                for (int i = 1; i < 12; ++i)
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

                    Console.WriteLine($"Text length: {textLength}, Key length {i}, Probability: {correct / N}.");
                }

            }
        }
    }
}
