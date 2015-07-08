package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.UiSettings;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;

/**
 * Created by kevin_000 on 09/06/2015.
 */
public class AroundMeFragment extends Fragment {

    private GoogleMap map;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_aroundme,
                container, false);

        GPSTracker gpsTracker = new GPSTracker(getActivity());

        if (gpsTracker.getIsGPSTrackingEnabled()) {
            map = ((MapFragment) getActivity().getFragmentManager().findFragmentById(R.id.map))
                    .getMap();

            UiSettings uist = map.getUiSettings();

            uist.setZoomControlsEnabled(true);
            uist.setAllGesturesEnabled(true);
            uist.setMyLocationButtonEnabled(true);

            gpsTracker.getLocation();
            double lat = gpsTracker.latitude;
            double lon = gpsTracker.longitude;
            LatLng POSITION = new LatLng(lat, lon);

            Marker position = map.addMarker(new MarkerOptions().position(POSITION)
                    .title("Lat = " + Double.toString(lat) + " : Lon = " + Double.toString(lon)));

            // Move the camera instantly to hamburg with a zoom of 15.
            map.moveCamera(CameraUpdateFactory.newLatLngZoom(POSITION, 15));

            // Zoom in, animating the camera.
            map.animateCamera(CameraUpdateFactory.zoomTo(10), 2000, null);

            map.setMapType(GoogleMap.MAP_TYPE_TERRAIN);
        }
        else {
            gpsTracker.showSettingsAlert();
        }
        return view;
    }

}
