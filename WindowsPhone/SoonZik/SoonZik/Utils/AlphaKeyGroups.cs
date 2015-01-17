using System.Collections.Generic;
using System.Globalization;
using Windows.Globalization.Collation;

namespace ConvertedListViewApp
{
    public class AlphaKeyGroups<T> : List<T>
    {
        /// <summary>
        /// The delegate that is used to get the key information.
        /// </summary>
        /// <param name="item">An object of type T</param>
        /// <returns>The key value to use for this object</returns>
        public delegate string GetKeyDelegate(T item);

        /// <summary>
        /// The Key of this group.
        /// </summary>
        public string Key { get; private set; }

        /// <summary>
        /// Public constructor.
        /// </summary>
        /// <param name="key">The key for this group.</param>
        public AlphaKeyGroups(string key)
        {
            Key = key;
        }

        /// <summary>
        /// Create a list of AlphaGroup<T> with keys set by a SortedLocaleGrouping.
        /// </summary>
        /// <param name="slg">The </param>
        /// <returns>Theitems source for a LongListSelector</returns>
        private static List<AlphaKeyGroups<T>> CreateGroups(CharacterGroupings slg)
        {
            List<AlphaKeyGroups<T>> list = new List<AlphaKeyGroups<T>>();

            foreach (CharacterGrouping key in slg)
            {
                if (string.IsNullOrWhiteSpace(key.Label) == false)
                    list.Add(new AlphaKeyGroups<T>(key.Label));
            }

            return list;
        }

        /// <summary>
        /// Create a list of AlphaGroup<T> with keys set by a SortedLocaleGrouping.
        /// </summary>
        /// <param name="items">The items to place in the groups.</param>
        /// <param name="ci">The CultureInfo to group and sort by.</param>
        /// <param name="getKey">A delegate to get the key from an item.</param>
        /// <param name="sort">Will sort the data if true.</param>
        /// <returns>An items source for a LongListSelector</returns>
        public static List<AlphaKeyGroups<T>> CreateGroups(IEnumerable<T> items, CultureInfo ci, GetKeyDelegate getKey, bool sort)
        {
            CharacterGroupings slg = new CharacterGroupings();
            List<AlphaKeyGroups<T>> list = CreateGroups(slg);

            foreach (T item in items)
            {
                string index = "";
                index = slg.Lookup(getKey(item));
                if (string.IsNullOrEmpty(index) == false)
                {
                    list.Find(a => a.Key == index).Add(item);
                }
            }

            if (sort)
            {
                foreach (AlphaKeyGroups<T> group in list)
                {
                    group.Sort((c0, c1) => { return ci.CompareInfo.Compare(getKey(c0), getKey(c1)); });
                }
            }

            return list;
        }

    }
}
