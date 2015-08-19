package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RadioGroup;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.UiSettings;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.Circle;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import org.json.JSONArray;
import org.json.JSONException;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 09/06/2015.
 */
public class ListeningFragment extends Fragment {

    MapView mapView;
    private GoogleMap map;
    private int[] rangeValueKiloMeters = {1, 5, 10, 50};
    private int strokeColor = 0xFF0000FF;
    private int shadeColor = 0x110000FF;
    private int currentRange = 1;
    private LatLng position;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_listening,
                container, false);

        final GPSTracker gpsTracker = new GPSTracker(getActivity());

        if (gpsTracker.getIsGPSTrackingEnabled()) {
            mapView = (MapView) view.findViewById(R.id.mapview);
            mapView.onCreate(savedInstanceState);

            map = mapView.getMap();
            map.setMyLocationEnabled(true);

            UiSettings uist = map.getUiSettings();

            uist.setZoomControlsEnabled(true);
            uist.setAllGesturesEnabled(true);
            uist.setMyLocationButtonEnabled(true);

            gpsTracker.getLocation();
            position = new LatLng(gpsTracker.latitude, gpsTracker.longitude);
            /*final double lat = gpsTracker.latitude;
            final double lon = gpsTracker.longitude;*/

            /*Marker position = map.addMarker(new MarkerOptions().position(POSITION)
                    .title("Lat = " + Double.toString(lat) + " : Lon = " + Double.toString(lon)));*/

            RadioGroup rangeGroup = (RadioGroup) view.findViewById(R.id.rangegroup);
            /*int radioButtonID = rangeGroup.getCheckedRadioButtonId();
            View radioButton = rangeGroup.findViewById(radioButtonID);
            int idx = rangeGroup.indexOfChild(radioButton);*/

            CircleOptions circleOptions = new CircleOptions()
                    .center(position)
                    .radius(currentRange * 1000)
                    .fillColor(shadeColor)
                    .strokeColor(strokeColor)
                    .strokeWidth(8);

            final Circle circle = map.addCircle(circleOptions);
            setMarker(gpsTracker.latitude, gpsTracker.longitude);

            rangeGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(RadioGroup group, int checkedId) {
                    // checkedId is the RadioButton selected
                    View radioButton = group.findViewById(checkedId);
                    int idx = group.indexOfChild(radioButton);
                    currentRange = rangeValueKiloMeters[idx];
                    position = new LatLng(gpsTracker.latitude, gpsTracker.longitude);

                    circle.setRadius(currentRange * 1000);
                    circle.setCenter(position);

                    setMarker(gpsTracker.latitude, gpsTracker.longitude);

                    map.moveCamera(CameraUpdateFactory.newLatLngZoom(position, 19));
                    map.animateCamera(CameraUpdateFactory.zoomTo(getZoomLevel(circle)), 2000, null);
                }
            });

            map.moveCamera(CameraUpdateFactory.newLatLngZoom(position, 19));

            map.animateCamera(CameraUpdateFactory.zoomTo(getZoomLevel(circle)), 2000, null);

            map.setMapType(GoogleMap.MAP_TYPE_TERRAIN);

            /*Listening.saveListening(1, lat, lon, new Date(), new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                    JSONObject obj = (JSONObject) response;

                    Log.v("SAVE LISTENING", obj.toString());
                }
            });*/
        }
        else {
            gpsTracker.showSettingsAlert();
        }
        return view;
    }

    @Override
    public void onResume() {
        mapView.onResume();
        super.onResume();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mapView.onDestroy();
    }

    @Override
    public void onLowMemory() {
        super.onLowMemory();
        mapView.onLowMemory();
    }

    @Override
    public void onPause() {
        super.onPause();
        mapView.onPause();
    }

    private void setMarker(double lat, double lon) {
        Listening.arroundMe(lat, lon, currentRange, new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                JSONArray data = (JSONArray) response;
                final ArrayList<Object> items = ActiveRecord.jsonArrayData(data, classT);

                for (Object item : items) {
                    Listening lst = (Listening) item;

                    map.addMarker(new MarkerOptions()
                                    .position(new LatLng(lst.getLatitude(), lst.getLongitude()))
                                    .title(lst.getUser().getUsername())
                                    .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_AZURE))
                                    .snippet(lst.getMusic().getTitle() + '\n' + lst.getMusic().getUser().getUsername())
                    );
                }

                Log.v("AROUND", data.toString());
            }
        });
    }

    public static float getZoomLevel(Circle circle){
        float zoomLevel = 15;
        if (circle != null){
            double radius = circle.getRadius();
            double scale = radius / 500;
            zoomLevel =(float) (16 - Math.log(scale) / Math.log(2));
        }
        return zoomLevel - 1.0f ;
    }

}
