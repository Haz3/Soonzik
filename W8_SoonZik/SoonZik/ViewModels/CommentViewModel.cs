using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class CommentViewModel
    {
        public ObservableCollection<Comment> commentlist { get; set; }

        public CommentViewModel()
        {

        }

        public CommentViewModel(string elem)
        {
            load_comments(elem);
        }

        async public void load_comments(string elem)
        {
            Exception exception = null;
            commentlist = new ObservableCollection<Comment>();

            //string elem = "news/" + id.ToString() + "/comments";
            elem += "/comments";

            try
            {
                var comments = (List<Comment>)await Http_get.get_object(new List<Comment>(), elem);

                foreach (var item in comments)
                    commentlist.Add(item);
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
            {
	            MessageDialog msgdlg = new MessageDialog(exception.Message,"Comment error");
	            await msgdlg.ShowAsync();
            }

        }
    }
}
