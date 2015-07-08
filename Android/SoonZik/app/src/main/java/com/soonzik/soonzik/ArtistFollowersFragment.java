package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 12/06/2015.
 */
public class ArtistFollowersFragment extends Fragment {
    private String redirectClass = "com.soonzik.soonzik.AlbumFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v;

        v = inflater.inflate(R.layout.fragment_artist_followers, container, false);

        int id = this.getArguments().getInt("artist_id");

        User.getFollowers(id, new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                JSONArray data = (JSONArray) response;
                final ArrayList<Object> fl = ActiveRecord.jsonArrayData(data, classT);

                UsersAdapter usersAdapter = new UsersAdapter(getActivity(), fl);
                ListView lv = (ListView) getActivity().findViewById(R.id.userslistview);
                lv.setAdapter(usersAdapter);
            }
        });

        return v;
    }

}
