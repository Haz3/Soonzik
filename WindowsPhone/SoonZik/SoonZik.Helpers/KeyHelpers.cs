namespace SoonZik.Helpers
{
    public class KeyHelpers
    {
        public static string GetUserKeyFromResponse(string key)
        {
            char[] delimiter = {' ', '"', '{', '}'};
            var word = key.Split(delimiter);
            var stringEncrypt = (word[4]);
            return stringEncrypt;
        }
    }
}