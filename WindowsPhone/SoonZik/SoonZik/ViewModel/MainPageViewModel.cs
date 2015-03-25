using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Ioc;
using Microsoft.Practices.ServiceLocation;

namespace SoonZik.ViewModel
{
    public class MainPageViewModel : ViewModelBase
    {
        #region Attribute

        private bool _connexionVisibility;

        public bool ConnexionVisibility
        {
            get
            {
                return _connexionVisibility;
            }
            set
            {
                _connexionVisibility = value;
                RaisePropertyChanged("ConnexionVisibility");
            }
        }

        private bool _pivotVisibility;

        public bool PivotVisibility
        {
            get
            {
                return _pivotVisibility;
            }
            set
            {
                _pivotVisibility = value;
                RaisePropertyChanged("PivotVisibility");

            }
        }

        #endregion


        #region Ctor
        public MainPageViewModel()
        {
            _connexionVisibility = false;
            _pivotVisibility = true;
        }
        #endregion

        #region Method

        #endregion

    }
}
