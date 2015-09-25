package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class MyContentPacksFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.PackFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View v =inflater.inflate(R.layout.fragment_mycontent_pack,container,false);

        MyContent ct = ActiveRecord.currentUser.getContent();

        final List<Object> packs = new ArrayList<Object>(ct.getPacks());

        PacksAdapter packsAdapter = new PacksAdapter(getActivity(), packs);
        ListView lv = (ListView) v.findViewById(R.id.packslistview);
        lv.setAdapter(packsAdapter);

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                Bundle bundle = new Bundle();
                bundle.putInt("pack_id", ((Pack) packs.get(position)).getId());
                Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                frg.setArguments(bundle);

                FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        /*User.getMusics(new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                JSONObject data = (JSONObject) response;
                final MyContent ct = (MyContent) ActiveRecord.jsonObjectData(data, classT);

                final List<Object> packs = new ArrayList<Object>(ct.getPacks());

                PacksAdapter packsAdapter = new PacksAdapter(getActivity(), packs);
                ListView lv = (ListView) getActivity().findViewById(R.id.packslistview);
                lv.setAdapter(packsAdapter);

                lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                    @Override
                    public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                        Bundle bundle = new Bundle();
                        bundle.putInt("pack_id", ((Pack) packs.get(position)).getId());
                        Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                        frg.setArguments(bundle);

                        FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                        tx.replace(R.id.main, frg);
                        tx.addToBackStack(null);
                        tx.commit();
                    }
                });
            }
        });*/

        return v;
    }
}
