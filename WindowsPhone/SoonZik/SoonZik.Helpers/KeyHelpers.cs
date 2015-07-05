namespace SoonZik.Helpers
{
    public class KeyHelpers
    {
        public static string GetUserKeyFromResponse(string key)
        {
            char[] delimiter = { ' ', '"', '{', '}' };
            string[] word = key.Split(delimiter);
            var stringEncrypt = (word[4]);
            return stringEncrypt;
        }
    }
}
