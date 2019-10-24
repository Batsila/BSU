using Lab2.Common.Models;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace Lab2.Common.Helpers
{
    public static class Extentions
    {
        public static RSAParameters ToRSAParameters(this PublicRSAParameters publicRSAParameters)
        {
            RSAParameters parameters = new RSAParameters
            {
                Exponent = publicRSAParameters.Exponent,
                Modulus = publicRSAParameters.Modulus
            };

            return parameters;
        }

        public static PublicRSAParameters ToPublicRSAParameters(this RSAParameters parameters)
        {
            var publicParameters = new PublicRSAParameters
            {
                Exponent = parameters.Exponent,
                Modulus = parameters.Modulus
            };

            return publicParameters;
        }
    }
}
