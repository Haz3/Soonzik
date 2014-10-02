/*
  In App.xaml:
  <Application.Resources>
      <vm:ViewModelLocator xmlns:vm="clr-namespace:SoonZik"
                           x:Key="Locator" />
  </Application.Resources>
  
  In the View:
  DataContext="{Binding Source={StaticResource Locator}, Path=ViewModelName}"

  You can also use Blend to do all this with the tool's support.
  See http://www.galasoft.ch/mvvm
*/

using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Ioc;
using Microsoft.Practices.ServiceLocation;

namespace SoonZik.ViewModel
{
    /// <summary>
    /// This class contains static references to all the view models in the
    /// application and provides an entry point for the bindings.
    /// </summary>
    public class ViewModelLocator
    {
        /// <summary>
        /// Initializes a new instance of the ViewModelLocator class.
        /// </summary>
        public ViewModelLocator()
        {
            ServiceLocator.SetLocatorProvider(() => SimpleIoc.Default);

            SimpleIoc.Default.Register<MainViewModel>();
            SimpleIoc.Default.Register<ConnexionViewModel>();
            SimpleIoc.Default.Register<AccueilViewModel>();
            SimpleIoc.Default.Register<NewsViewModel>();
            SimpleIoc.Default.Register<PackViewModel>();
            SimpleIoc.Default.Register<ProfilViewModel>();
        }

        public MainViewModel Main
        {
            get
            { return ServiceLocator.Current.GetInstance<MainViewModel>(); }
        }

        public ConnexionViewModel Connexion
        {
            get { return ServiceLocator.Current.GetInstance<ConnexionViewModel>(); }
        }

        public AccueilViewModel Accueil
        {
            get { return ServiceLocator.Current.GetInstance<AccueilViewModel>(); }
        }

        public NewsViewModel News
        {
            get { return ServiceLocator.Current.GetInstance<NewsViewModel>(); }
        }
        
        public PackViewModel Pack
        {
            get { return ServiceLocator.Current.GetInstance<PackViewModel>(); }
        }

        public ProfilViewModel Profil
        {
            get { return ServiceLocator.Current.GetInstance<ProfilViewModel>(); }
        }

        public static void Cleanup()
        {
            // TODO Clear the ViewModels
        }
    }
}