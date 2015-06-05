package com.soonzik.testsupermodel;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 28/05/2015.
 */
public class SearchPacksFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_search_pack, container, false);

        String query = this.getArguments().getString("searchtext");
        if (query == null) {
            query = "";
        }
        ActiveRecord.search(-1, 0, query, "pack", new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                JSONObject object = (JSONObject) response;
                Search sc = (Search) ActiveRecord.jsonObjectData(object, classT);

                final List<Object> all = new ArrayList<Object>();

                ArrayList<Pack> ms = sc.getPack();
                if (ms != null)
                    all.addAll(ms);

                if (!all.isEmpty()) {
                    PacksAdapter packsAdapter = new PacksAdapter(getActivity(), all);
                    ListView lv = (ListView) getActivity().findViewById(R.id.packslistview);
                    lv.setAdapter(packsAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                            Toast.makeText(getActivity(), (all.get(position)).toString(), Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            }
        });

        return v;
    }
}
