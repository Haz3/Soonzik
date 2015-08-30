package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by Kevin on 2015-08-30.
 */
public class ConcertsListFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view;


        view = inflater.inflate(R.layout.listfragment_concerts,
                container, false);

        try {
            ActiveRecord.index("Concert", new ActiveRecord.OnJSONResponseCallback() {

                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> concerts = ActiveRecord.jsonArrayData(data, classT);

                    ConcertsAdapter concertsAdapter = new ConcertsAdapter(getActivity(), concerts);
                    ListView lv = (ListView) getActivity().findViewById(R.id.concertslistview);
                    lv.setAdapter(concertsAdapter);
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return view;
    }
}
