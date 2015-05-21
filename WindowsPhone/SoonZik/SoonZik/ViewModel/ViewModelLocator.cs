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

using GalaSoft.MvvmLight.Ioc;
using GalaSoft.MvvmLight.Views;
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
            SimpleIoc.Default.Register<INavigationService>(() => new NavigationService());

            SimpleIoc.Default.Register<MainViewModel>();
            SimpleIoc.Default.Register<ConnexionViewModel>();
            SimpleIoc.Default.Register<AccueilViewModel>();
            SimpleIoc.Default.Register<NewsViewModel>();
            SimpleIoc.Default.Register<PackViewModel>();
            SimpleIoc.Default.Register<ProfilUserViewModel>();
            SimpleIoc.Default.Register<ProfilArtisteViewModel>();
            SimpleIoc.Default.Register<MenuViewModel>();
            SimpleIoc.Default.Register<ViewModel>();
            SimpleIoc.Default.Register<BattleViewModel>();
            SimpleIoc.Default.Register<GeolocViewModel>();
            SimpleIoc.Default.Register<FriendViewModel>();
            SimpleIoc.Default.Register<ConversationViewModel>();
            SimpleIoc.Default.Register<MainPageViewModel>();
            SimpleIoc.Default.Register<PlayerViewModel>();
            SimpleIoc.Default.Register<ExplorerViewModel>();
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

        public ProfilUserViewModel ProfilUser
        {
            get { return ServiceLocator.Current.GetInstance<ProfilUserViewModel>(); }
        }
        
        public ProfilArtisteViewModel ProfilArtiste
        {
            get { return ServiceLocator.Current.GetInstance<ProfilArtisteViewModel>(); }
        }

        public MenuViewModel Menu
        {
            get { return ServiceLocator.Current.GetInstance<MenuViewModel>(); }
        }

        public ViewModel View
        {
            get { return ServiceLocator.Current.GetInstance<ViewModel>(); }
        }

        public BattleViewModel Battle
        {
            get { return ServiceLocator.Current.GetInstance<BattleViewModel>(); }
        }

        public GeolocViewModel Geoloc
        {
            get { return ServiceLocator.Current.GetInstance<GeolocViewModel>(); }
        }

        public FriendViewModel Friend
        {
            get { return ServiceLocator.Current.GetInstance<FriendViewModel>(); }
        }

        public ConversationViewModel Conversation
        {
            get { return ServiceLocator.Current.GetInstance<ConversationViewModel>(); }
        }

        public MainPageViewModel MainPage
        {
            get { return ServiceLocator.Current.GetInstance<MainPageViewModel>(); }
        }

        public PlayerViewModel Player
        {
            get { return ServiceLocator.Current.GetInstance<PlayerViewModel>(); }
        }

        public ExplorerViewModel Explorer
        {
            get { return ServiceLocator.Current.GetInstance<ExplorerViewModel>(); }
        }
       
        public static void Cleanup()
        {
            // TODO Clear the ViewModels
        }
    }
}