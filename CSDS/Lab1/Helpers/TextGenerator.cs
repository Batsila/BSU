using System;
using System.IO;

namespace Lab1.Helpers
{
    public class TextGenerator
    {
        private readonly string _source;
        private readonly Random _random;

        public TextGenerator(string path = "Text.txt")
        {
            _random = new Random();
            using (FileStream stream = new FileStream(path, FileMode.Open))
            {
                using (StreamReader reader = new StreamReader(stream))
                {
                    _source = reader.ReadToEnd();
                }
                stream.Close();
            }
        }

        public string GetText(int length)
        {
            if (_source.Length < length)
                throw new Exception("Source text is too short.");

            var startIndex = _random.Next(0, _source.Length - length - 1);

            return _source.Substring(startIndex, length);
        }
    }
}
