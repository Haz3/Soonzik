using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using System.Collections.ObjectModel;


namespace SoonZik.Tools
{
    class Get_coment
    {
        public ObservableCollection<Comment> commentlist { get; set; }

        async public void load_coments(string elem)
        {
            commentlist = new ObservableCollection<Comment>();

            List<Comment> list = new List<Comment>();
            var comments = (List<Comment>)await Http_get.get_object(list, elem);

            foreach (var item in comments)
                commentlist.Add(item);
        }
    }
}
