package com.soonzik.soonzik;

import android.app.DialogFragment;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 16/06/2015.
 */
public class AlbumFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_album,
                container, false);

        int id = this.getArguments().getInt("album_id");

        try {
            ActiveRecord.show("Album", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    final Album al = (Album) ActiveRecord.jsonObjectData(data, classT);

                    List<Object> ms = new ArrayList<Object>(al.getMusics());
                    User art = al.getUser();
                    if (art != null) {
                        for (Object m : ms) {
                            ((Music) m).setUser(art);
                            ((Music) m).setAlbum(al);
                        }
                    }

                    TextView title = (TextView) view.findViewById(R.id.albumtitle);
                    title.setText(al.getTitle());

                    TextView artistname = (TextView) view.findViewById(R.id.artistname);
                    artistname.setText(al.getUser().getUsername());

                    artistname.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Bundle bundle = new Bundle();
                            bundle.putInt("artist_id", al.getUser().getId());
                            Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                            frg.setArguments(bundle);

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
                            tx.addToBackStack(null);
                            tx.commit();
                        }
                    });

                    TextView nbTitle = (TextView) view.findViewById(R.id.nbtitle);
                    nbTitle.setText(Integer.toString(ms.size()));

                    final ImageView likedAlbum = (ImageView) view.findViewById(R.id.album_like);
                    final TextView nbLikes = (TextView) view.findViewById(R.id.nb_likes);
                    nbLikes.setText(Integer.toString(al.getLikes()));

                    if (al.isHasLiked()) {
                        likedAlbum.setImageResource(R.drawable.like);
                    } else {
                        likedAlbum.setImageResource(R.drawable.unlike);
                    }

                    likedAlbum.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            if (al.isHasLiked()) {
                                User.unlikeContent("Albums", al.getId(), new ActiveRecord.OnJSONResponseCallback() {
                                    @Override
                                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                                        likedAlbum.setImageResource(R.drawable.unlike);
                                        al.setHasLiked(!al.isHasLiked());
                                        al.setLikes(al.getLikes() - 1);
                                        nbLikes.setText(Integer.toString(al.getLikes()));
                                    }
                                });
                            } else {
                                User.likeContent("Albums", al.getId(), new ActiveRecord.OnJSONResponseCallback() {
                                    @Override
                                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                                        likedAlbum.setImageResource(R.drawable.like);
                                        al.setHasLiked(!al.isHasLiked());
                                        al.setLikes(al.getLikes() + 1);
                                        nbLikes.setText(Integer.toString(al.getLikes()));
                                    }
                                });
                            }
                        }
                    });

                    TextView price = (TextView) view.findViewById(R.id.price);
                    price.setText(Double.toString(al.getPrice()) + "$");

                    TextView albumaction = (TextView) view.findViewById(R.id.albumaction);
                    albumaction.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            DialogFragment newFragment = new AlbumActionDialogFragment();
                            Bundle bundle = new Bundle();
                            bundle.putInt("album_id", al.getId());

                            Log.v("ALBUM_ID", Integer.toString(al.getId()));

                            newFragment.setArguments(bundle);
                            newFragment.show(getActivity().getFragmentManager(), "com.soonzik.soonzik.AlbumActionDialogFragment");
                        }
                    });

                    new Utils.ImageLoadTask("http://soonzikapi.herokuapp.com/assets/albums/" + al.getImage(), (ImageView) view.findViewById(R.id.albumpicture)).execute();

                    MusicsAdapter musicsAdapter = new MusicsAdapter(getActivity(), ms);
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
