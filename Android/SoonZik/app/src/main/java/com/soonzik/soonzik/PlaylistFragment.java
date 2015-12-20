package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
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
                    final Playlist playlist = (Playlist) ActiveRecord.jsonObjectData(data, classT);

                    final List<Object> musics = new ArrayList<Object>(playlist.getMusics());

                    TextView name = (TextView) view.findViewById(R.id.playlistname);
                    name.setText(playlist.getName());

                    TextView nbTitle = (TextView) view.findViewById(R.id.nbtitle);
                    nbTitle.setText(Integer.toString(musics.size()));

                    MusicsAdapter musicsAdapter = new MusicsAdapter(getActivity(), musics);
                    ListView lv = (ListView) getActivity().findViewById(R.id.musicslistview);
                    lv.setAdapter(musicsAdapter);

                    ImageView playPlaylist = (ImageView) view.findViewById(R.id.play_playlist);
                    playPlaylist.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            Bundle bundle = new Bundle();

                            ArrayList<Integer> ids = new ArrayList<Integer>();
                            for (Music ms : playlist.getMusics()) {
                                ids.add(ms.getId());
                            }
                            bundle.putIntegerArrayList("music_ids", ids);
                            bundle.putInt("index_music", 0);

                            ArrayList<String> artist_names = new ArrayList<String>();
                            for (Music ms : playlist.getMusics()) {
                                artist_names.add(ms.getUser().getUsername());
                            }
                            bundle.putStringArrayList("artist_names", artist_names);

                            ArrayList<String> title_songs= new ArrayList<String>();
                            for (Music ms : playlist.getMusics()) {
                                title_songs.add(ms.getTitle());
                            }
                            bundle.putStringArrayList("title_songs", title_songs);

                            ArrayList<String> title_albums = new ArrayList<String>();
                            for (Music ms : playlist.getMusics()) {
                                title_albums.add(ms.getAlbum().getTitle());
                            }
                            bundle.putStringArrayList("title_albums", title_albums);

                            ArrayList<String> image_albums = new ArrayList<String>();
                            for (Music ms : playlist.getMusics()) {
                                image_albums.add("http://soonzikapi.herokuapp.com/assets/albums/" + ms.getAlbum().getImage());
                            }
                            bundle.putStringArrayList("image_albums", image_albums);

                            Fragment frg = Fragment.instantiate(getActivity(), "com.soonzik.soonzik.Player");
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

        return view;
    }

}
