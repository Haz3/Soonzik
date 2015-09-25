package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
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
public class CommentaryListFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View v;

        v = inflater.inflate(R.layout.listfragment_comments,
                container, false);

        final String cls = this.getArguments().getString("class");
        final int id = this.getArguments().getInt("to_comment_id");

        try {
            ActiveRecord.getComments(cls, id, 0, 0, new ActiveRecord.OnJSONResponseCallback() {

                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    try {
                        Class<?> classTComment = Class.forName("com.soonzik.soonzik.Commentary");

                        final ArrayList<Object> cmts = ActiveRecord.jsonArrayData(data, classTComment);

                        CommentaryAdapter commentaryAdapter = new CommentaryAdapter(getActivity(), cmts);
                        ListView lv = (ListView) getActivity().findViewById(R.id.commentslistview);
                        lv.setAdapter(commentaryAdapter);
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    }

                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        final Object those = this;

        Button sendTweet = (Button) v.findViewById(R.id.sendcomment);
        sendTweet.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(final View view) {
                String msg = ((EditText) v.findViewById(R.id.edittextcomment)).getText().toString();

                ActiveRecord.addComment(cls, id, msg, new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                        JSONObject obj = (JSONObject) response;

                        Tweet tweet = (Tweet) ActiveRecord.jsonObjectData(obj, classT);
                        ((EditText) v.findViewById(R.id.edittextcomment)).setText("");

                        Toast.makeText(getActivity(), "Comment Send", Toast.LENGTH_SHORT).show();
                    }
                });
            }
        });

        return v;
    }
}
