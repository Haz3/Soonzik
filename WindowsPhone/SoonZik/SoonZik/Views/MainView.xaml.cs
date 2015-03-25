using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;

// Pour en savoir plus sur le modèle d’élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkID=390556
using GalaSoft.MvvmLight.Ioc;
using Microsoft.Practices.ServiceLocation;
using SoonZik.Utils;
using SoonZik.ViewModel;

namespace SoonZik.Views
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class MainView : Page
    {
        public MainView()
        {
            this.InitializeComponent();
            this.Loaded += OnLoaded;
        }

        private void OnLoaded(object sender, RoutedEventArgs routedEventArgs)
        {
            this.PivotGlobal.Loaded += delegate(object o, RoutedEventArgs args)
            {
                var vm = DataContext as MainViewModel;
                if (vm != null)
                {
                    vm.GetPivotExecute.Execute(this.PivotGlobal);
                    vm.GetStoryBoardExecute.Execute(this.MenuStoryBoardBack);
                    vm.GetToggleButton.Execute(this.ToggleButtonMenu);
                }
            };
        }

        /// <summary>
        /// Invoqué lorsque cette page est sur le point d'être affichée dans un frame.
        /// </summary>
        /// <param name="e">Données d'événement décrivant la manière dont l'utilisateur a accédé à cette page.
        /// Ce paramètre est généralement utilisé pour configurer la page.</param>
        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
        }

        private void MenuAloneClose_OnCompleted(object sender, object e)
        {
            ToggleButtonMenu.IsChecked = false;
            MenuStoryBoardBack.Pause();
        }

        private void SearchAloneBack_OnCompleted(object sender, object e)
        {
            ToggleButtonSearch.IsChecked = false;
            SearchStoryBoardBack.Pause();
        }
    }
}
