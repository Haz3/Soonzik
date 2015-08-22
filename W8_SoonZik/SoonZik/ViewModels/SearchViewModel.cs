using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using SoonZik.ViewModels.Command;
using System.Windows.Input;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class SearchViewModel
    {
        public Search search_result { get; set; }
        public string search_value { get; set; }

        public ICommand do_search
        {
            get;
            private set;
        }

        public SearchViewModel()
        {
            do_search = new SearchCommand(this);
        }

        public async void search()
        {
            
            var search = (Search)await Http_get.get_object(new Search(), "search?query=" + search_value);
            //await new MessageDialog(search.user.ToString(), "Search").ShowAsync();
        }
    }
}
