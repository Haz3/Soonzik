using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.ViewModels;
using SoonZik.Tools;
using System.Collections.ObjectModel;
using SoonZik.Models;
using Windows.UI.Popups;
using SoonZik.ViewModels.Command;
using System.Windows.Input;

namespace SoonZik.ViewModels
{
    class ExplorerViewModel
    {
        public ObservableCollection<Pack> pack_list { get; set; }
        public ObservableCollection<Album> album_list { get; set; }
        public ObservableCollection<User> artist_list { get; set; }
        public ObservableCollection<Genre> genre_list { get; set; }

        public ExplorerViewModel()
        {
            load_explorer();
        }

        async void load_explorer()
        {
            Exception exception = null;
            pack_list = new ObservableCollection<Pack>();
            album_list = new ObservableCollection<Album>();
            artist_list = new ObservableCollection<User>();
            genre_list = new ObservableCollection<Genre>();
            
            try
            {
                var pack = (List<Pack>)await Http_get.get_object(new List<Pack>(), "packs");
                var album = (List<Album>)await Http_get.get_object(new List<Album>(), "albums");
                var artist = (List<User>)await Http_get.get_object(new List<User>(), "users/artists");
                var genre = (List<Genre>)await Http_get.get_object(new List<Genre>(), "genres");

                foreach (var item in pack)
                    pack_list.Add(item);
                foreach (var item in album)
                    album_list.Add(item);
                foreach (var item in artist)
                    artist_list.Add(item);
                foreach (var item in genre)
                    genre_list.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de l'explorer").ShowAsync();
        }
    }
}
