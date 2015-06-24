using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;
using Windows.Storage.Streams;

namespace SoonZik.Helpers
{
    public class EncriptSha256
    {
        public static string EncriptStringToSha256(string myString)
        {
            IBuffer input = CryptographicBuffer.ConvertStringToBinary(myString, BinaryStringEncoding.Utf8);

            var hasher = HashAlgorithmProvider.OpenAlgorithm("SHA256");
            IBuffer hashed = hasher.HashData(input);

            return CryptographicBuffer.EncodeToHexString(hashed);
        }
    }
}
