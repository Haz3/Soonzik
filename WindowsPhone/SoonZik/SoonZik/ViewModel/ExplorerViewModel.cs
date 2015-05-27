using System.Collections.Generic;
using System.Collections.ObjectModel;
using GalaSoft.MvvmLight;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class ExplorerViewModel : ViewModelBase
    {
        #region Attribute
        public ObservableCollection<Genre> ListGenres
        {
            get { return _listGenres; }
            set
            {
                _listGenres = value;
                RaisePropertyChanged("ListGenres");
            }
        }

        private ObservableCollection<Genre> _listGenres;
        #endregion

        #region Ctor

        public ExplorerViewModel()
        {
            Charge();
        }
        #endregion

        #region Method
        public async void Charge()
        {
            var test = new HttpRequestGet();
            var list = (List<Genre>)await test.GetListObject(new List<HttpRequest.Poco.Genre>(), "genres");
            _listGenres = new ObservableCollection<Genre>();

            foreach (var item in list)
            {
                _listGenres.Add(item);
            }
        }
        #endregion
    }
}
