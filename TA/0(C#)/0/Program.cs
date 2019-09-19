using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _0
{
    class Program
    {
        static void Main(string[] args)
        {
            StreamReader input = new StreamReader("input.txt");
            StreamWriter output = new StreamWriter("output.txt");
            HashSet<long> set = new HashSet<long>();
            string inString = "";
            while (inString != null)
            {
                inString = input.ReadLine();
                if (inString != null)
                    set.Add(long.Parse(inString));
            }
            long sum = 0;
            foreach (long x in set)
            {
                sum += x;
            }
            output.WriteLine(sum);
            output.Close();
        }
    }
}
