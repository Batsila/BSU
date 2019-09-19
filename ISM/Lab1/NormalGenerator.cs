using Meta.Numerics.Functions;
using System;

namespace Lab1
{
    /// <summary>
    /// Normally distributed random generator
    /// </summary>
    public class NormalGenerator
    {
        private readonly MGenerator _mGenerator;

        public double StandardDeviation { get; private set; }
        public double Expectation { get; private set; }

        public NormalGenerator(double expectation, double standardDeviation, int seed = 65539)
        {
            _mGenerator = new MGenerator(seed);

            Expectation = expectation;
            StandardDeviation = standardDeviation;
        }

        public double NextRand()
        {
            var baseVariable = _mGenerator.NextRand();

            return Expectation + StandardDeviation * Math.Sqrt(2) 
                * AdvancedMath.InverseErf(2 * baseVariable - 1);
        }
    }
}
