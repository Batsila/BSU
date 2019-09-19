using System;

namespace Lab2
{
    /// <summary>
    /// Trapezoidal distributed random generator
    /// </summary>
    public class TrapezoidalGenerator
    {
        private readonly MGenerator _mGenerator;

        public double A { get; private set; }
        public double B { get; private set; }
        public double C { get; private set; }
        public double D { get; private set; }
        public double Density
        {
            get
            {
                return B + D - A - C;
            }
        }

        public TrapezoidalGenerator(double a, double b, double c, double d, int seed = 65539)
        {
            _mGenerator = new MGenerator(seed);

            A = a;
            B = b;
            C = c;
            D = d;
        }

        public double NextRand()
        {
            var baseVariable = _mGenerator.NextRand();

            if (baseVariable < (C - A) / Density)
            {
                var d = Math.Sqrt(baseVariable * (C - A) * Density);
                return A + d;
            }

            if (baseVariable > 1 - (B - D) / Density)
            {
                var d = Math.Sqrt((1 - baseVariable) * (B - D) * Density);
                return D - d;
            }

            return (baseVariable * Density + A + C) / 2;
        }
    }
}
