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
using Windows.UI.Xaml;

namespace SoonZik.ViewModels
{
    class PackViewModel : INotifyPropertyChanged
    {
        private Pack _pack;
        public Pack pack
        {
            get { return _pack; }
            set
            {
                _pack = value;
                OnPropertyChanged("pack");
            }
        }

        private Visibility _desc_fr_visibility;
        public Visibility desc_fr_visibility
        {
            get { return _desc_fr_visibility; }
            set
            {
                _desc_fr_visibility = value;
                OnPropertyChanged("desc_fr_visibility");
            }
        }

        private Visibility _desc_en_visibility;
        public Visibility desc_en_visibility
        {
            get { return _desc_en_visibility; }
            set
            {
                _desc_en_visibility = value;
                OnPropertyChanged("desc_en_visibility");
            }
        }

        //public Visibility visible;

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public PackViewModel(int id)
        {
            load_pack(id);
            desc_fr_visibility = Visibility.Visible;
            desc_en_visibility = Visibility.Visible;
        }

        async public void load_pack(int id)
        {
            Exception exception = null;

            try
            {
                pack = await Http_get.get_pack_by_id(id);

                // Detect current language and set visibility
                if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                    desc_en_visibility = Visibility.Collapsed;
                else
                    desc_fr_visibility = Visibility.Collapsed;

                // SET DESC if null to avoid crash ...
                if (pack.descriptions.Any())
                {
                    if (pack.descriptions[0].description == null)
                        pack.descriptions[0].description = "PAS DE DESCRIPTION DISPONIBLE";
                    if (pack.descriptions.Count == 2)
                        if (pack.descriptions[1].description == null)
                            pack.descriptions[1].description = "NO DESCRIPTION AVAILABLE";
                }
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "pack error").ShowAsync();
        }
    }
}

