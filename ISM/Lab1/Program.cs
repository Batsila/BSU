using System;
using System.Collections.Generic;

namespace Lab1
{
    class Program
    {
        static double ConductExperiment(int a, int b, double expectation, double standardDeviation, int n = 1000)
        {
            var errors = 0;
            var generator = new NormalGenerator(expectation, standardDeviation);

            for (int i = 0; i < n; ++i)
            {
                var rand = generator.NextRand();
                if (rand < a || rand > b)
                    ++errors;
            }

            return (double)errors / n;
        }

        static void Main()
        {
            int a = 57;
            int b = 63;
            var deviations = new List<int> { 1, 2, 3 };

            foreach (var deviation in deviations)
            {
                Console.WriteLine($"Standard deviation {deviation}: {ConductExperiment(a, b, (a + b) / 2, deviation)}");
            }

            var expectations = new List<int> { 58, 65 };

            foreach (var expectation in expectations)
            {
                Console.WriteLine($"Expectation {expectation}: {ConductExperiment(a, b, expectation, 1)}");
            }

            Console.ReadKey();
        }
    }
}
