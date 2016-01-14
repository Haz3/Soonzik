package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class ExplorerMusicsFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.Player";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v;

        v = inflater.inflate(R.layout.fragment_explorer_music,container,false);
        Log.v("EXPLORER", "HEY");
        ActiveRecord.suggest("music", 10, new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {

                Log.v("EXPLORER", response.toString());

                JSONArray data = (JSONArray) response;
                final ArrayList<Object> sg = ActiveRecord.jsonArrayData(data, classT);

                MusicsAdapter musicsAdapter = new MusicsAdapter(getActivity(), sg);
                ListView lv = (ListView) getActivity().findViewById(R.id.musicslistview);
                lv.setAdapter(musicsAdapter);

                lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                    @Override
                    public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                        Log.v("PLAY", "JOUE!");

                        Bundle bundle = new Bundle();
                        bundle.putInt("music_id", ((Music) sg.get(position)).getId());

                        Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                        frg.setArguments(bundle);

                        FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                        tx.replace(R.id.main, frg);
                        tx.commit();
                    }
                });
            }
        });

        return v;
    }
}
