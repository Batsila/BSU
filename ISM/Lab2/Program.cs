using System;
using System.Collections.Generic;
using System.Linq;

namespace Lab2
{
    class Program
    {
        private const int P = 10000;
        private const int N1 = 2;
        private const int N2 = 2;

        static List<double> ConductExperiment()
        {
            var uniformGenerator = new UniformGenerator(9, 10.2);
            var trapezoidalGenerator = new TrapezoidalGenerator(8, 12, 9, 10);
            var discreteGenerator = new DiscreteGenerator(-0.1, 0.1, 0, 0.1, 0.2);

            var res = new List<double>();

            for (int it1 = 0; it1 < 1000; ++it1)
            {
                var i1 = uniformGenerator.NextRand();
                var i2 = trapezoidalGenerator.NextRand();
                var s = P * Math.Pow(1 + i1 / 100, N1) * Math.Pow(1 + i2 / 100, N2);
                var h = 2.6;
                var ksi = 0.0;
                var j = 1.0;
                for (int it2 = 0; it2 < 16; ++it2)
                {
                    j *= (1 + (h + ksi) / 100);
                    ksi += discreteGenerator.NextRand();
                    h += 0.4;
                }
                res.Add(s / j);
            }

            return res;
        }

        static void Main(string[] args)
        {
            var c = ConductExperiment();

            Console.WriteLine($"Min(C) = {c.Min()}");
            Console.WriteLine($"Max(C) = {c.Max()}");
            var avg = c.Average();
            Console.WriteLine($"E(C) = {avg}");
            Console.WriteLine($"D(C) = {Math.Sqrt(c.Select(x => Math.Pow(x - avg, 2)).Average())}");
            Console.WriteLine($"P(13000 <= C <= 13200) = {c.Count(x => 13000 <= x && x <= 13200)}");

            Console.ReadKey();
        }
    }
}
