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
public class PackAlbumsFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.AlbumFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v;
        int id = this.getArguments().getInt("pack_id");

        v = inflater.inflate(R.layout.fragment_pack_album, container, false);
        try {
            ActiveRecord.show("Pack", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    Pack pack = (Pack) ActiveRecord.jsonObjectData(data, classT);

                    final List<Object> albums = new ArrayList<Object>(pack.getAlbums());

                    AlbumsAdapter albumsAdapter = new AlbumsAdapter(getActivity(), albums);
                    ListView lv = (ListView) v.findViewById(R.id.albumslistview);
                    lv.setAdapter(albumsAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                            Bundle bundle = new Bundle();
                            bundle.putInt("album_id", ((Album) albums.get(position)).getId());
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
