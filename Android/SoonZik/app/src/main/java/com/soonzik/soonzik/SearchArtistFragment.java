package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 28/05/2015.
 */
public class SearchArtistFragment extends Fragment {
    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_search_user, container, false);

        String query = this.getArguments().getString("searchtext");
        if (query == null) {
            query = "";
        }
        ActiveRecord.search(-1, 0, query, "artist", new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                JSONObject object = (JSONObject) response;
                Search sc = (Search) ActiveRecord.jsonObjectData(object, classT);

                final List<Object> all = new ArrayList<Object>();

                final ArrayList<User> us = sc.getArtist();
                if (us != null)
                    all.addAll(us);

                if (!all.isEmpty()) {
                    UsersAdapter usersAdapter = new UsersAdapter(getActivity(), all);
                    ListView lv = (ListView) getActivity().findViewById(R.id.userslistview);
                    lv.setAdapter(usersAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                            Bundle bundle = new Bundle();
                            bundle.putInt("artist_id", us.get(position).getId());
                            Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                            frg.setArguments(bundle);

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
                            tx.addToBackStack(null);
                            tx.commit();
                        }
                    });
                }
            }
        });

        return v;
    }
}
