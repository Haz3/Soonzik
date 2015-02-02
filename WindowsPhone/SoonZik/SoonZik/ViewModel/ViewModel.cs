using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Controls;

namespace SoonZik.ViewModel
{
    public class ViewModel : INotifyPropertyChanged
    {

       #region Attribute

        public event PropertyChangedEventHandler PropertyChanged;
        private Acceuil _acceuil;
        public Acceuil ContentModel {
            get
            {
                return _acceuil;
            }
            set
            {
                _acceuil = value;
                OnPropertyChanged("ContentModel");
            }
        }

        #endregion

        #region Ctor
        public ViewModel()
        {
            this.ContentModel = new Acceuil();
        }
        #endregion


        #region InotifyPropertyChanged
        private void OnPropertyChanged(string propertyName)
        {
            if (this.PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
        }
        #endregion
    }
    }

        
