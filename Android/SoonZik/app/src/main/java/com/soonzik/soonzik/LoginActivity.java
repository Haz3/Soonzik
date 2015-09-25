package com.soonzik.soonzik;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;

/**
 * Created by kevin_000 on 02/08/2015.
 */
public class LoginActivity extends Activity {

    CallbackManager callbackManager;

    Button loginButton;
    Button signinButton;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FacebookSdk.sdkInitialize(getApplicationContext());
        setContentView(R.layout.fragment_login);

        if (ActiveRecord.currentUser != null) {
            Intent mainActivity = new Intent(getApplicationContext(), MainActivity.class);
            startActivity(mainActivity);

            finish();
        }

        ((EditText) findViewById(R.id.loginUsername)).setText("user_one@gmail.com");
        ((EditText) findViewById(R.id.loginPassword)).setText("azertyuiop");


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
                    }
                });
            }
        });

        signinButton = (Button) findViewById(R.id.signinButton);
        signinButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent signinActivity = new Intent(getApplicationContext(), SignInActivity.class);
                startActivity(signinActivity);
            }
        });


        callbackManager = CallbackManager.Factory.create();
        LoginButton loginBut = (LoginButton) findViewById(R.id.login_but);
        loginBut.registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {

                Log.v("FACEBOOK", "OKKKKK");

                User.socialLogin(loginResult.getAccessToken().getUserId(), "facebook", loginResult.getAccessToken().getToken(), new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException, JSONException {
                        JSONObject obj = (JSONObject) response;

                        User res = (User) ActiveRecord.jsonObjectData(obj, classT);
                        ActiveRecord.setCurrentUser(res);

                        Intent mainActivity = new Intent(getApplicationContext(), MainActivity.class);
                        startActivity(mainActivity);

                        finish();
                    }
                });
            }

            @Override
            public void onCancel() {
            }

            @Override
            public void onError(FacebookException e) {

            }
        });

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }
}
