package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class MyContentMusicsFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.Player";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_mycontent_music,container,false);

        User.getMusics(new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                JSONObject data = (JSONObject) response;
                final MyContent ct = (MyContent) ActiveRecord.jsonObjectData(data, classT);
                ActiveRecord.currentUser.setContent(ct);

                Log.v("MyContent", ct.toString());

                final List<Object> sg = new ArrayList<Object>(ct.getMusics());

                MusicContentAdapter musicContentAdapter = new MusicContentAdapter(getActivity(), sg);
                ListView lv = (ListView) getActivity().findViewById(R.id.musicslistview);
                lv.setAdapter(musicContentAdapter);
            }
        });

        return v;
    }
}
