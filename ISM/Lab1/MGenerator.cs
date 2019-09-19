using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab1
{
    /// <summary>
    /// MacLaren–Marsaglia generator for base random variable 
    /// </summary>
    public class MGenerator
    {
        private double _alpha;
        private double _beta;
        private double _m;

        public MGenerator(int seed = 65539)
        {
            _alpha = seed;
            _beta = 65539;
            _m = 2147483648;
        }

        public double NextRand()
        {
            _alpha = (_alpha * _beta) % _m;

            return _alpha / _m;
        }
    }
}
