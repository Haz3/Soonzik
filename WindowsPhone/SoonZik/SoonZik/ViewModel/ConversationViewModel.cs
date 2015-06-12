using Windows.Phone.UI.Input;
using GalaSoft.MvvmLight;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class ConversationViewModel : ViewModelBase
    {
        #region Attribute

        public INavigationService Navigation;

        #endregion

        #region Ctor

        public ConversationViewModel()
        {
            HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;
        }
        #endregion

        #region Method

        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs backPressedEventArgs)
        {
            backPressedEventArgs.Handled = true;
            Navigation.GoBack();
        }
        #endregion

    }
}
