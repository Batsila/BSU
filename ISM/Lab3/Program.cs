using System;

namespace Lab3
{
    class Program
    {
        private const double A = 0;
        private const double B = 9;

        private delegate double Func(double x);

        static double Function(double x)
        {
            return Math.Pow(Math.Cos(x), 2) / (1 + Math.Pow(x, 2));
        }

        static double SymmetryFunction(double x)
        {
            return (Function(x) + Function(A + B - x)) / 2;
        }

        static double DoMontecarlo(Func func, int samples = 10000)
        {
            var uniformGenerator = new UniformGenerator(A, B);
            var ans = 0.0;

            for (int i = 0; i < samples; ++i)
            {
                ans += func(uniformGenerator.NextRand());
            }

            return ans / samples * (B - A);
        }

        static void Main(string[] args)
        {
            Console.WriteLine($"Function = {DoMontecarlo(Function)}");
            Console.WriteLine($"Symmetry function = {DoMontecarlo(SymmetryFunction)}");

            Console.ReadKey();
        }
    }
}
