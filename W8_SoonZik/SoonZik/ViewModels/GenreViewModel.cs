using Newtonsoft.Json.Linq;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    public class GenreViewModel
    {
        public ObservableCollection<Genre> genrelist { get; set; }

        public GenreViewModel()
        {
            load_genres();
        }

        async public void load_genres()
        {
            Exception exception = null;
            var request = new Http_get();

            try
            {
                genrelist = new ObservableCollection<Genre>();
                List<Genre> list = new List<Genre>();

                var genres = (List<Genre>)await request.get_object_list(list, "genres");


                ///// TEST //////
                foreach (var item in genres)
                {
                    item.musics = await load_musics(item);
                    genrelist.Add(item);
                }
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Genre error");
                await msgdlg.ShowAsync();
            }
        }

        async public Task<List<Music>> load_musics(Genre genre)
        {
            Exception exception = null;
            var request = new Http_get();

            try
            {
                var genres = (Genre)await request.get_object_list(genre, "genres/" + genre.id);
                //genre.musics = genres.musics;

                return genres.musics;
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Genre musics error");
                await msgdlg.ShowAsync();
            }
            return null;
        }
    }
}
