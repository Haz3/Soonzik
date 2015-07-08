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

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class FriendsListFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.MessageListFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view;

        if (ActiveRecord.currentUser != null) {
            view = inflater.inflate(R.layout.listfragment_friends,
                    container, false);

            ActiveRecord.currentUser.getFriends(ActiveRecord.currentUser.getId(), new ActiveRecord.OnJSONResponseCallback() {

                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> friends = ActiveRecord.jsonArrayData(data, classT);

                    FriendsAdapter friendsAdapter = new FriendsAdapter(getActivity(), friends);
                    ListView lv = (ListView) getActivity().findViewById(R.id.friendslistview);
                    lv.setAdapter(friendsAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                            Bundle bundle = new Bundle();
                            bundle.putInt("user_id", ((User) friends.get(position)).getId());
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
        }
        else {
            view = inflater.inflate(R.layout.fragment_userunlogged,
                    container, false);
        }


        return view;
    }
}
