package com.soonzik.soonzik;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;

/**
 * Created by kevin_000 on 02/08/2015.
 */
public class LoginActivity extends Activity {

    Button loginButton;
    Button signinButton;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.fragment_login);

        if (ActiveRecord.currentUser != null) {
            Intent mainActivity = new Intent(getApplicationContext(), MainActivity.class);
            startActivity(mainActivity);

            finish();
        }

        ((EditText) findViewById(R.id.loginUsername)).setText("kevin.lansel@epitech.eu");
        ((EditText) findViewById(R.id.loginPassword)).setText("dgo8ffzd");


        loginButton = (Button) findViewById(R.id.loginButton);
        loginButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                String username = ((EditText) findViewById(R.id.loginUsername)).getText().toString();
                String password = ((EditText) findViewById(R.id.loginPassword)).getText().toString();

                ActiveRecord.login(username, password, new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, Fragment.InstantiationException, IllegalAccessException, java.lang.InstantiationException {
                        JSONObject obj = (JSONObject) response;

                        User res = (User) ActiveRecord.jsonObjectData(obj, classT);
                        ActiveRecord.setCurrentUser(res);

                        Intent mainActivity = new Intent(getApplicationContext(), MainActivity.class);
                        startActivity(mainActivity);

                        finish();
                        /*FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
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

                        ((ActionBarActivity) getActivity()).getSupportActionBar().setTitle(names[idx]);*/
                    }
                });
            }
        });

        /*signinButton = (Button) findViewById(R.id.signinButton);
        signinButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent signinActivity = new Intent(getApplicationContext(), SignInActivity.class);
                startActivity(signinActivity);
            }
        });*/

    }
}
