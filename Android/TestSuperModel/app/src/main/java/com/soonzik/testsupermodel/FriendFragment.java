package com.soonzik.testsupermodel;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class FriendFragment extends Fragment{

    TextView nameText;
    TextView idText;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_friend,
                container, false);

        int id = this.getArguments().getInt("friend_id");

        try {
            ActiveRecord.show("User", id, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    User user = (User) ActiveRecord.jsonObjectData(data, classT);

                    nameText = (TextView) getActivity().findViewById(R.id.friendName);
                    idText = (TextView) getActivity().findViewById(R.id.friendId);

                    nameText.setText(user.getUsername());
                    idText.setText(Integer.toString(user.getId()));
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return view;
    }
}
