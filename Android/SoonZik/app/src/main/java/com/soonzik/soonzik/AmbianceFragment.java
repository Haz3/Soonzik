package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by Kevin on 2016-01-07.
 */
public class AmbianceFragment extends Fragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_ambiance,
                container, false);

        int ambiance_id = this.getArguments().getInt("ambiance_id");

        try {
            ActiveRecord.show("Ambiance", ambiance_id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                    JSONObject data = (JSONObject) response;
                    final Ambiance ab = (Ambiance) ActiveRecord.jsonObjectData(data, classT);

                    Log.v("AMBIANCE", ab.toString());

                    List<Object> ms = new ArrayList<Object>(ab.getMusics());

                    MusicsAdapter musicsAdapter = new MusicsAdapter(getActivity(), ms);
                    ListView lv = (ListView) getActivity().findViewById(R.id.musicslistview);
                    lv.setAdapter(musicsAdapter);
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return (view);
    }


}
