namespace Lab3
{
    /// <summary>
    /// Uniform distributed random generator
    /// </summary>
    public class UniformGenerator
    {
        private readonly MGenerator _mGenerator;

        public double A { get; private set; }
        public double B { get; private set; }

        public UniformGenerator(double a, double b, int seed = 65539)
        {
            _mGenerator = new MGenerator(seed);

            A = a;
            B = b;
        }

        public double NextRand()
        {
            var baseVariable = _mGenerator.NextRand();

            return baseVariable * (B - A) + A;
        }
    }
}
