using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab2
{
    public class DiscreteGenerator
    {
        private readonly MGenerator _mGenerator;

        public double A { get; private set; }
        public double B { get; private set; }
        public double C { get; private set; }
        public double Ap { get; private set; }
        public double Bp { get; private set; }

        public DiscreteGenerator(double a, double b, double c, double ap, double bp, int seed = 65539)
        {
            _mGenerator = new MGenerator(seed);

            A = a;
            B = b;
            C = c;
            Ap = ap;
            Bp = bp;
        }

        public double NextRand()
        {
            var baseVariable = _mGenerator.NextRand();

            if (baseVariable < Ap)
                return A;

            if (baseVariable < Bp)
                return B;

            return C;
        }
    }
}
