using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class AmbianceViewModel: INotifyPropertyChanged
    {
        public ObservableCollection<Ambiance> ambiances_list { get; set; }

        private Ambiance _selected_ambiance;
        public Ambiance selected_ambiance
        {
            get { return _selected_ambiance; }
            set
            {
                _selected_ambiance = value;
                OnPropertyChanged("selected_ambiance");
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public AmbianceViewModel()
        {
            load_ambiances();
        }

        async void load_ambiances()
        {
            Exception exception = null;
            ambiances_list = new ObservableCollection<Ambiance>();

            try
            {
                var ambiances = (List<Ambiance>)await Http_get.get_object(new List<Ambiance>(), "ambiances");

                foreach (var item in ambiances)
                    ambiances_list.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Ambiances error").ShowAsync();
        }
    }
}
