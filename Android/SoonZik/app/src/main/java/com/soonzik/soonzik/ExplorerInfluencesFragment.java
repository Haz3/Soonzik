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

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class ExplorerInfluencesFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v =inflater.inflate(R.layout.fragment_explorer_influence,container,false);

        try {
            ActiveRecord.index("Influence", new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> influences = ActiveRecord.jsonArrayData(data, classT);

                    ExplorerInfluencesAdapter influencesAdapter = new ExplorerInfluencesAdapter(getActivity(), influences);
                    ListView lv = (ListView) v.findViewById(R.id.influenceslistview);
                    lv.setAdapter(influencesAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                            Bundle bumdle = new Bundle();
                            ArrayList<Genre> genres = ((Influence) influences.get(position)).getGenres();

                            String tmp = "[";
                            int i = 0;
                            for (Genre genre : genres) {
                                tmp += "{\"color_hexa\":\"" + genre.getColor_hexa()
                                        + "\",\"id\":" + Integer.toString(genre.getId())
                                        + ",\"color_name\":\"" + genre.getColor_name()
                                        + "\",\"style_name\":\"" + genre.getStyle_name()
                                        + "\"}" ;
                                i++;
                                if (i < genres.size()) {
                                    tmp += ",";
                                }
                            }
                            tmp += "]";
                            bumdle.putString("genres_json", tmp);

                            Fragment frg = Fragment.instantiate(getActivity(), "com.soonzik.soonzik.ExplorerGenresFragment");
                            frg.setArguments(bumdle);

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
                            tx.addToBackStack(null);
                            tx.commit();

                            //Toast.makeText(getActivity(), ((Influence) influences.get(position)).getName(), Toast.LENGTH_SHORT).show();
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
