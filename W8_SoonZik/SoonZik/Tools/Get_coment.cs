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
            var request = new Http_get();
            commentlist = new ObservableCollection<Comment>();


            List<Comment> list = new List<Comment>();
            var comments = (List<Comment>)await request.get_object_list(list, elem);

            foreach (var item in comments)
                commentlist.Add(item);

        }
    }
}
