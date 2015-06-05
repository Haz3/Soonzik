package com.soonzik.testsupermodel;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class BattlesListFragment extends Fragment {

    private String redirectClass = "com.soonzik.testsupermodel.BattleFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.listfragment_battles,
                container, false);

        try {
            ActiveRecord.index("Battle", new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> battles = ActiveRecord.jsonArrayData(data, classT);
                    BattlesAdapter adapter = new BattlesAdapter(getActivity(), battles);

                    ListView lv = (ListView) getActivity().findViewById(R.id.battleslistview);
                    lv.setAdapter(adapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                            Bundle bundle = new Bundle();
                            bundle.putInt("battle_id", ((Battle) battles.get(position)).getId());
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

        return view;
    }

}
