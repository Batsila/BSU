using Meta.Numerics.Functions;
using System;

namespace Lab1
{
    /// <summary>
    /// Normally distributed random generator
    /// </summary>
    public class NormalGenerator
    {
        private double _standardDeviation;
        private double _expectation;
        private MGenerator _mGenerator;

        public NormalGenerator(double expectation, double standardDeviation, int seed = 65539)
        {
            _mGenerator = new MGenerator(seed);
            _expectation = expectation;
            _standardDeviation = standardDeviation;
        }

        public double NextRand()
        {
            var baseVariable = _mGenerator.NextRand();

            return _expectation + _standardDeviation * Math.Sqrt(2) 
                * AdvancedMath.InverseErf(2 * baseVariable - 1);
        }
    }
}
