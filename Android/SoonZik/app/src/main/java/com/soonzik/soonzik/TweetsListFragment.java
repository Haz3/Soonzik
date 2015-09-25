package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Kevin on 2015-08-30.
 */
public class TweetsListFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View v;


        v = inflater.inflate(R.layout.listfragment_tweets,
                container, false);

        try {
            ActiveRecord.index("Tweet", new ActiveRecord.OnJSONResponseCallback() {

                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> tweets = ActiveRecord.jsonArrayData(data, classT);

                    TweetsAdapter tweetsAdapter = new TweetsAdapter(getActivity(), tweets);
                    ListView lv = (ListView) getActivity().findViewById(R.id.tweetslistview);
                    lv.setAdapter(tweetsAdapter);
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        Button sendTweet = (Button) v.findViewById(R.id.sendtweet);
        sendTweet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View view) {
                String msg = ((EditText) v.findViewById(R.id.edittexttweet)).getText().toString();
                Map<String, String> data = new HashMap<String, String>();

                data.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
                data.put("msg", msg);

                ActiveRecord.save("Tweet", data, true, new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                        JSONObject obj = (JSONObject) response;

                        Tweet tweet = (Tweet) ActiveRecord.jsonObjectData(obj, classT);
                        ((EditText) v.findViewById(R.id.edittexttweet)).setText("");

                        Toast.makeText(getActivity(), "Tweet Send", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });

        return v;
    }
}
