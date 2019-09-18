using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

        public NormalGenerator(double expectation, double standardDeviation, long seed = 65539)
        {
            _mGenerator = new MGenerator(seed);
            _expectation = expectation;
            _standardDeviation = standardDeviation;
        }

        public double NextRand()
        {
            var baseVariable = _mGenerator.NextRand();

            return _expectation + _standardDeviation * Math.Sqrt(2) * Meta.Numerics.Functions.AdvancedMath.Erf(2 * baseVariable - 1);
        }
    }
}
