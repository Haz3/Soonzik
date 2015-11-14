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
 * Created by kevin_000 on 12/06/2015.
 */
public class PackArtistsFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v;
        int id = this.getArguments().getInt("pack_id");

        v = inflater.inflate(R.layout.fragment_pack_artist, container, false);
        try {
            ActiveRecord.show("Pack", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    Pack pack = (Pack) ActiveRecord.jsonObjectData(data, classT);

                    ArrayList<Album> albums = pack.getAlbums();
                    final List<Object> artists = new ArrayList<Object>();

                    if (albums != null) {
                        User tmp = null;
                        for (Album alb : albums) {
                            tmp = alb.getUser();
                            if (tmp != null && !artists.contains(tmp)) {
                                artists.add(alb.getUser());
                            }
                        }
                    }

                    UsersAdapter usersAdapter = new UsersAdapter(getActivity(), artists);
                    ListView lv = (ListView) getActivity().findViewById(R.id.artistslistview);
                    lv.setAdapter(usersAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                            Bundle bundle = new Bundle();
                            bundle.putInt("artist_id", ((User) artists.get(position)).getId());
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
        return v;
    }
}
