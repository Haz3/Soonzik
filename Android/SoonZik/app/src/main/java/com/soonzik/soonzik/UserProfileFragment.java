package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;

/**
 * Created by kevin_000 on 07/05/2015.
 */
public class UserProfileFragment extends Fragment {

    Button updateUserButton;

    private String redirectClass = "com.soonzik.soonzik.UserProfileUpdateFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view;

        if (ActiveRecord.currentUser != null) {
            view = inflater.inflate(R.layout.fragment_userprofil,
                    container, false);
            try {
                ActiveRecord.show("User", ActiveRecord.currentUser.getId(), false, new ActiveRecord.OnJSONResponseCallback() {

                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                        JSONObject obj = (JSONObject) response;

                        User res = (User) ActiveRecord.jsonObjectData(obj, classT);

                        ((TextView) getActivity().findViewById(R.id.emailUser)).setText(res.getEmail());
                        ((TextView) getActivity().findViewById(R.id.lnameUser)).setText(res.getLname());
                        ((TextView) getActivity().findViewById(R.id.fnameUser)).setText(res.getFname());
                        ((TextView) getActivity().findViewById(R.id.usernameUser)).setText(res.getUsername());
                        ((TextView) getActivity().findViewById(R.id.birthdayUser)).setText(res.getBirthday());
                        ((TextView) getActivity().findViewById(R.id.descriptionUser)).setText(res.getDescription());
                        ((ImageView) getActivity().findViewById(R.id.imageUser)).setImageResource(R.drawable.ic_profile);
                    }
                });
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }

            updateUserButton = (Button) view.findViewById(R.id.updateUserButton);
            updateUserButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                    tx.replace(R.id.main, Fragment.instantiate(getActivity(), redirectClass));
                    tx.addToBackStack(null);
                    tx.commit();

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
