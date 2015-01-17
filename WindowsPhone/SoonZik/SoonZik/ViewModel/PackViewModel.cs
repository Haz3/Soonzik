using System;
using System.Collections.ObjectModel;
using Windows.UI.Xaml.Media.Imaging;

namespace SoonZik.ViewModel
{
    public class PackViewModel
    {
        public ObservableCollection<Object> Datas { get; set; }

        public PackViewModel()
        {
            var datas = new ObservableCollection<Object>
            {
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic01.jpg", UriKind.Absolute)),
                    Title = "01"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic03.jpg", UriKind.Absolute)),
                    Title = "02"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic05.jpg", UriKind.Absolute)),
                    Title = "03"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic04.jpg", UriKind.Absolute)),
                    Title = "04"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic02.jpg", UriKind.Absolute)),
                    Title = "05"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic06.jpg", UriKind.Absolute)),
                    Title = "06"
                }
            };

            this.Datas = datas;

        }
    }

    public class Data
    {
        public BitmapImage BitmapImage { get; set; }
        public String Title { get; set; }
    }
}
