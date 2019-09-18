using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1
{
    class Program
    {
        static double ConductExperiment(int a, int b, double expectation, double standardDeviation, int n = 1000)
        {
            var errors = 0;
            var generator = new NormalGenerator(expectation, standardDeviation, DateTime.Now.Ticks);

            for (int i = 0; i < n; ++i)
            {
                var rand = generator.NextRand();
                if (rand < a || rand > b)
                    ++errors;
            }

            return (double)errors / n;
        }

        static void Main(string[] args)
        {
            int a = 57;
            int b = 63;
            double expectation = (a + b) / 2;

            var p = ConductExperiment(a, b, expectation, 1);

            Console.WriteLine(p);

            Console.ReadKey();
        }
    }
}
