using System;
using System.Threading.Tasks;
using Windows.Devices.Geolocation;
using GalaSoft.MvvmLight;

namespace SoonZik.ViewModel
{
    public class GeolocalisationViewModel : ViewModelBase
    {
        #region Ctor

        public GeolocalisationViewModel()
        {
            var task = Task.Run(async () => await InitVariable());
            task.Wait();
        }

        #endregion

        #region Method

        private async Task InitVariable()
        {
            _myGeolocator = new Geolocator();
            var Geoposition = _myGeolocator.GetGeopositionAsync();

            _myGeolocator = new Geolocator();
            var myGeoposition = await _myGeolocator.GetGeopositionAsync();
            UserLocation = myGeoposition.Coordinate;
        }

        #endregion

        #region Attrivute

        private Geolocator _myGeolocator;

        private Geocoordinate _userLocation;

        public Geocoordinate UserLocation
        {
            get { return _userLocation; }
            set
            {
                _userLocation = value;
                RaisePropertyChanged("UserLocation");
            }
        }

        #endregion
    }
}