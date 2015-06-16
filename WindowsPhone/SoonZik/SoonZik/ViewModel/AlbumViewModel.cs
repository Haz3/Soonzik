using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class AlbumViewModel : ViewModelBase
    {
        #region Attribute

        private string _imageAlbum;
        public string ImageAlbum
        {
            get { return _imageAlbum;}
            set
            {
               _imageAlbum = value;
               RaisePropertyChanged("ImageAlbum"); 
            }
        }

        private List<Music> _listMusics;
        public List<Music> ListMusics
        {
            get { return _listMusics; }
            set
            {
                _listMusics = value;
                RaisePropertyChanged("ListMusics");
            }
        }

        private Album _theAlbum;
        public Album TheAlbum
        {
            get { return _theAlbum;}
            set
            {
                _theAlbum = value;
                RaisePropertyChanged("TheAlbum");
            }
        }

        public static Album MyAlbum { get; set; }
        #endregion

        #region ctor

        public AlbumViewModel()
        {
            if (MyAlbum != null)
            {
                TheAlbum = MyAlbum;            
                var task = Task.Run(async () => await Charge());
                task.Wait();
            }
            //ImageAlbum = TheAlbum.image == String.Empty ? new Uri("ms-appx:///Resources/Icones/disc.png", UriKind.Absolute).ToString() : TheAlbum.image;

        }
        #endregion

        #region Method
        public async Task Charge()
        {
            var request = new HttpRequestGet();
            try
            {
                TheAlbum = (Album)await request.GetObject(new Album(), "albums", MyAlbum.id.ToString());
                ListMusics = TheAlbum.musics;
            }
            catch (Exception e)
            {

            }
        }
        #endregion


    }
}
