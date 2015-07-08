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

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 24/06/2015.
 */
public class MessageListFragment extends Fragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view;

        /*Map<String, String> info = new HashMap<>();
        info.put("user_id", "4");
        info.put("dest_id", "6");
        info.put("msg", "Test un peu plus long pour voir comment se comporte la bubule de caca");
        info.put("session", "First");

        ActiveRecord.save("Message", info, true, new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                Log.v("MSG", "AJOUTe");
            }
        });

        view = inflater.inflate(R.layout.fragment_userunlogged,
                container, false);*/

        if (ActiveRecord.currentUser != null) {
            view = inflater.inflate(R.layout.listfragment_messages,
                    container, false);

            int id = this.getArguments().getInt("user_id");
            Message.conversation(id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> messages = ActiveRecord.jsonArrayData(data, classT);

                    MessagesAdapter messagesAdapter = new MessagesAdapter(getActivity(), messages);
                    ListView lv = (ListView) getActivity().findViewById(R.id.messageslistview);
                    lv.setAdapter(messagesAdapter);
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
