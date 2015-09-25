package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
            ActiveRecord.show("Album", id, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    final Album al = (Album) ActiveRecord.jsonObjectData(data, classT);

                    List<Object> ms = new ArrayList<Object>(al.getMusics());
                    User art = al.getUser();
                    if (art != null) {
                        for (Object m : ms) {
                            ((Music) m).setUser(art);
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

                    TextView price = (TextView) view.findViewById(R.id.price);
                    price.setText(Double.toString(al.getPrice()) + "$");

                    Button addToCart = (Button) view.findViewById(R.id.addtocart);
                    addToCart.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            final Map<String, String> data = new HashMap<String, String>();
                            data.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
                            data.put("typeObj", "Album");
                            data.put("obj_id", Integer.toString(al.getId()));

                            ActiveRecord.save("Cart", data, true, new ActiveRecord.OnJSONResponseCallback() {
                                @Override
                                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                                    JSONObject obj = (JSONObject) response;

                                    Cart cart = (Cart) ActiveRecord.jsonObjectData(obj, classT);
                                    Toast.makeText(getActivity(), "Album add to cart", Toast.LENGTH_SHORT).show();
                                }
                            });
                        }
                    });

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
