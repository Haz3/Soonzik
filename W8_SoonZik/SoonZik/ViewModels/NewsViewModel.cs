using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using SoonZik.Models;

namespace SoonZik.ViewModels
{
   public class NewsViewModel : INotifyPropertyChanged
    {
       public List<News> newslist;


       public List<News> NewsList
       {
           get { return NewsList; }
           set { NotifyPropertyChanged(ref newslist, value); }
       }

        public event PropertyChangedEventHandler PropertyChanged ;
        public void NotifyPropertyChanged ( string nomPropriete )
        {
            if (PropertyChanged != null )
              PropertyChanged (this , new PropertyChangedEventArgs (nomPropriete));
        }

        private bool NotifyPropertyChanged <T> (ref T variable , T valeur , [CallerMemberName] string nomPropriete = null)
        {
            if (object.Equals(variable, valeur))
                return false;
            variable = valeur;
            NotifyPropertyChanged (nomPropriete);
            return true;
        }

        public NewsViewModel()
        {
            NewsList = new List<News>();
        }
    }
}
