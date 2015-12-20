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
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class MyContentMusicsFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.Player";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_mycontent_music,container,false);

        /*MyContent ct = ActiveRecord.currentUser.getContent();

        final List<Object> sg = new ArrayList<Object>(ct.getMusics());

        MusicsAdapter musicsAdapter = new MusicsAdapter(getActivity(), sg);
        ListView lv = (ListView) v.findViewById(R.id.musicslistview);
        lv.setAdapter(musicsAdapter);

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                Toast.makeText(getActivity(), (sg.get(position)).toString(), Toast.LENGTH_SHORT).show();

                Log.v("PLAY", "JOUE!");

                Bundle bundle = new Bundle();
                bundle.putInt("music_id", 1);

                Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                frg.setArguments(bundle);

                FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.commit();
            }
        });*/

        User.getMusics(new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                JSONObject data = (JSONObject) response;
                final MyContent ct = (MyContent) ActiveRecord.jsonObjectData(data, classT);
                ActiveRecord.currentUser.setContent(ct);

                Log.v("MyContent", ct.toString());

                final List<Object> sg = new ArrayList<Object>(ct.getMusics());

                MusicsAdapter musicsAdapter = new MusicsAdapter(getActivity(), sg);
                ListView lv = (ListView) getActivity().findViewById(R.id.musicslistview);
                lv.setAdapter(musicsAdapter);

                lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                    @Override
                    public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                        Toast.makeText(getActivity(), (sg.get(position)).toString(), Toast.LENGTH_SHORT).show();

                        Log.v("PLAY", "JOUE!");

                        Bundle bundle = new Bundle();
                        bundle.putInt("music_id", 1);

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
