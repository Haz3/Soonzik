package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 13/05/2015.
 */
public class PlaylistsListFragment extends Fragment {

    TextView playlistName;
    Button deletePlaylistButtom;

    private String redirectClass = "com.soonzik.soonzik.PlaylistFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view;

        if (ActiveRecord.currentUser != null) {
            view = inflater.inflate(R.layout.listfragment_playlists,
                    container, false);

            Map<String, Object> linkparams = new HashMap<String, Object>();
            Map<String, String> attribute = new HashMap<String, String>();
            attribute.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
            linkparams.put("attribute", attribute);
            try {
                ActiveRecord.find("Playlist", linkparams, new ActiveRecord.OnJSONResponseCallback() {

                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                        JSONArray data = (JSONArray) response;

                        final ArrayList<Object> playlists = ActiveRecord.jsonArrayData(data, classT);

                        PlaylistsAdapter playlistsAdapter = new PlaylistsAdapter(getActivity(), playlists);

                        ListView lv = (ListView) getActivity().findViewById(R.id.playlistslistview);
                        lv.setAdapter(playlistsAdapter);

                        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                            @Override
                            public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                                Bundle bundle = new Bundle();
                                bundle.putInt("playlist_id", ((Playlist) playlists.get(position)).getId());
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

                    /*final Playlist playlist = (Playlist) ActiveRecord.jsonObjectData(obj, classT);
                    playlistName = (TextView) getActivity().findViewById(R.id.playlistName);
                    playlistName.setText(playlist.getName());
                    deletePlaylistButtom = (Button) getActivity().findViewById(R.id.deletePlaylistButtom);

                    deletePlaylistButtom.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            ActiveRecord.destroy("Playlist", playlist.getId(), new ActiveRecord.OnJSONResponseCallback() {
                                @Override
                                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                                    Log.v("DESTROY PLAYLIST", "C'est OK");
                                }
                            });
                        }
                    });*/

        }
        else {
            view = inflater.inflate(R.layout.fragment_userunlogged,
                    container, false);
        }

        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        super.onCreateOptionsMenu(menu, inflater);
        inflater.inflate(R.menu.menu_playlists, menu);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }


}
