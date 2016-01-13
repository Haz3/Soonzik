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
import org.json.JSONException;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by Kevin on 2016-01-07.
 */
public class ExplorerAmbiancesFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.AmbianceFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v = inflater.inflate(R.layout.fragment_explorer_ambiance, container, false);

        try {
            ActiveRecord.index("Ambiance", new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> ambiances = ActiveRecord.jsonArrayData(data, classT);

                    AmbiancesAdapter ambiancesAdapter = new AmbiancesAdapter(getActivity(), ambiances);
                    ListView lv = (ListView) v.findViewById(R.id.ambiancelistview);
                    lv.setAdapter(ambiancesAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                            Bundle bundle = new Bundle();
                            bundle.putInt("ambiance_id", ((Ambiance) ambiances.get(position)).getId());
                            Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                            frg.setArguments(bundle);

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
                            tx.addToBackStack(null);
                            tx.commit();
                        }
                    });
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }






        return (v);
    }

}

