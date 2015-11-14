package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;;import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 13/05/2015.
 */
public class PlaylistFragment extends Fragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_playlist,
                        container, false);

        int id = this.getArguments().getInt("playlist_id");

        try {
            ActiveRecord.show("Playlist", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    Playlist playlist = (Playlist) ActiveRecord.jsonObjectData(data, classT);

                    List<Object> musics = new ArrayList<Object>(playlist.getMusics());

                    TextView name = (TextView) view.findViewById(R.id.playlistname);
                    name.setText(playlist.getName());

                    TextView nbTitle = (TextView) view.findViewById(R.id.nbtitle);
                    nbTitle.setText(Integer.toString(musics.size()));

                    MusicsAdapter musicsAdapter = new MusicsAdapter(getActivity(), musics);
                    ListView lv = (ListView) getActivity().findViewById(R.id.musicslistview);
                    lv.setAdapter(musicsAdapter);

                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return view;
    }

}
