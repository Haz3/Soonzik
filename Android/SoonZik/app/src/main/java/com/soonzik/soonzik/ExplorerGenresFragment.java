package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class ExplorerGenresFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v =inflater.inflate(R.layout.fragment_explorer_genre, container, false);

        //int id = this.getArguments().getInt("influence_id");
        try {
            JSONArray tmp = new JSONArray(this.getArguments().getString("genres_json"));
            final ArrayList<Object> genres = ActiveRecord.jsonArrayData(tmp, Class.forName("com.soonzik.soonzik.Genre"));

            ExplorerGenresAdapter genresAdapter = new ExplorerGenresAdapter(getActivity(), genres);

            ListView lv = (ListView) v.findViewById(R.id.genreslistview);
            lv.setAdapter(genresAdapter);

            lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                    Toast.makeText(getActivity(), ((Genre) genres.get(position)).getName(), Toast.LENGTH_SHORT).show();

                    Bundle bundle = new Bundle();
                    bundle.putInt("genre_id", ((Genre) genres.get(position)).getId());
                    Fragment frg = Fragment.instantiate(getActivity(), "com.soonzik.soonzik.ExplorerResultFragment");
                    frg.setArguments(bundle);

                    FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                    tx.replace(R.id.main, frg);
                    tx.addToBackStack(null);
                    tx.commit();

                }
            });
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (java.lang.InstantiationException e) {
            e.printStackTrace();
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        /*try {
            ActiveRecord.show("Influence", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {

                    JSONObject obj = (JSONObject) response;
                    Influence inf = (Influence) ActiveRecord.jsonObjectData(obj, classT);

                    final ArrayList<Object> genres = new ArrayList<Object>(inf.getGenres());

                    ExplorerGenresAdapter genresAdapter = new ExplorerGenresAdapter(getActivity(), genres);
                    ListView lv = (ListView) getActivity().findViewById(R.id.genreslistview);
                    lv.setAdapter(genresAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                            Toast.makeText(getActivity(), ((Genre) genres.get(position)).getName(), Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }*/

        return v;
    }
}
