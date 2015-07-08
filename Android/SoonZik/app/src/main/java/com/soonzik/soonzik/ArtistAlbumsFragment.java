package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 12/06/2015.
 */
public class ArtistAlbumsFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.AlbumFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v;

        v = inflater.inflate(R.layout.fragment_artist_albums, container, false);

        int id = this.getArguments().getInt("artist_id");

        Map<String, Object> params = new HashMap<String, Object>();
        Map<String, String> atr = new HashMap<>();

        atr.put("user_id", Integer.toString(id));
        params.put("attribute", atr);

        try {
            ActiveRecord.find("Album", params, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;
                    final ArrayList<Object> al = ActiveRecord.jsonArrayData(data, classT);

                    AlbumsAdapter albumsAdapter = new AlbumsAdapter(getActivity(), al);
                    ListView lv = (ListView) getActivity().findViewById(R.id.albumslistview);
                    lv.setAdapter(albumsAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                            Bundle bundle = new Bundle();
                            bundle.putInt("album_id", ((Album) al.get(position)).getId());
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
