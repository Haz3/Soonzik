package com.soonzik.soonzik;

import android.support.v4.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;


public class LoginFragment extends Fragment {

    Button loginButton;
    Button signinButton;
    private String redirectClass = "com.soonzik.soonzik.UserProfileFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_login,
                container, false);

        /*
            TODO : delete at the end of dev
         */

        ((EditText) view.findViewById(R.id.loginUsername)).setText("user_one@gmail.com");
        ((EditText) view.findViewById(R.id.loginPassword)).setText("azertyuiop");


        loginButton = (Button) view.findViewById(R.id.loginButton);
        loginButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                String username = ((EditText) view.findViewById(R.id.loginUsername)).getText().toString();
                String password = ((EditText) view.findViewById(R.id.loginPassword)).getText().toString();

                ActiveRecord.login(username, password, new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException, java.lang.InstantiationException {
                        JSONObject obj = (JSONObject) response;

                        User res = (User) ActiveRecord.jsonObjectData(obj, classT);
                        ActiveRecord.setCurrentUser(res);

                        FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                        tx.replace(R.id.main, Fragment.instantiate(getActivity(), redirectClass));
                        tx.commit();

                        String[] names = getResources().getStringArray(R.array.nav_names);
                        String[] classes = getResources().getStringArray(R.array.nav_classes);

                        int idx = 0;
                        for (int i = 0; i < classes.length; i++) {
                            if (classes[i].equals(redirectClass)) {
                                idx = i;
                            }
                        }

                        ((ActionBarActivity) getActivity()).getSupportActionBar().setTitle(names[idx]);
                    }
                });
            }
        });

        signinButton = (Button) view.findViewById(R.id.signinButton);
        signinButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent signinActivity = new Intent(getActivity().getApplicationContext(), SignInActivity.class);
                startActivity(signinActivity);
            }
        });

        return view;
    }
}
