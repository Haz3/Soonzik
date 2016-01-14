package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 28/05/2015.
 */
public class SearchAllFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_search_all, container, false);

        String query = this.getArguments().getString("searchtext");

        if (query == null) {
            query = "";
        }

        ActiveRecord.search(-1, 0, query, "", new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                JSONObject object = (JSONObject) response;
                Search sc = (Search) ActiveRecord.jsonObjectData(object, classT);

                final List<Object> all = new ArrayList<Object>();

                ArrayList<Music> ms = sc.getMusic();
                if (ms != null)
                    all.addAll(ms);
                ArrayList<Album> ab = sc.getAlbum();
                if (ab != null)
                    all.addAll(ab);
                ArrayList<Pack> pc = sc.getPack();
                if (pc != null)
                    all.addAll(pc);
                ArrayList<User> at = sc.getArtist();
                if (at != null)
                    all.addAll(at);
                ArrayList<User> us = sc.getUser();
                if (us != null)
                    all.addAll(us);

                if (!all.isEmpty()) {
                    SearchAllAdapter allAdapter = new SearchAllAdapter(getActivity(), all);
                    ListView lv = (ListView) getActivity().findViewById(R.id.alllistview);
                    lv.setAdapter(allAdapter);
                }
            }
        });

        return v;
    }

}
