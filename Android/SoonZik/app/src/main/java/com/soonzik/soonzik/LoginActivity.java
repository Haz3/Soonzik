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

import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterLoginButton;

import io.fabric.sdk.android.Fabric;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;

/**
 * Created by kevin_000 on 02/08/2015.
 */
public class LoginActivity extends Activity {

    // Note: Your consumer key and secret should be obfuscated in your source code before shipping.
/*    private static final String TWITTER_KEY = "kEB2H1DUxgZ9upJSvavu9yaQ8";
    private static final String TWITTER_SECRET = "YkTTmNcgOmGqNaGAdayCfjCIDr2ev84sLPfLa28Y7OOz6qrBg0";*/

    private static final String TWITTER_KEY = "ooWEcrlhooUKVOxSgsVNDJ1RK";
    private static final String TWITTER_SECRET = "BtLpq9ZlFzXrFklC2f1CXqy8EsSzgRRVPZrKVh0imI2TOrZAan";

    CallbackManager callbackManager;
    TwitterLoginButton loginTwitter;

    Button loginButton;
    Button signinButton;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TwitterAuthConfig authConfig = new TwitterAuthConfig(TWITTER_KEY, TWITTER_SECRET);
        Fabric.with(this, new Twitter(authConfig));

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

                        Log.v("TWITTER", response.toString());

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

        loginTwitter = (TwitterLoginButton) findViewById(R.id.login_twitter);
        loginTwitter.setCallback(new Callback<TwitterSession>() {
            @Override
            public void success(Result<TwitterSession> result) {
                // Do something with result, which provides a TwitterSession for making API calls
                Log.v("Twitter", "OKKKKK");

                User.socialLogin(Long.toString(result.data.getUserId()), "twitter", result.data.getAuthToken().token, new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException, JSONException {
                        JSONObject obj = (JSONObject) response;

                        Log.v("TWITTER", response.toString());

                        Log.v("TWITTER", classT.toString());

                        User res = (User) ActiveRecord.jsonObjectData(obj, classT);
                        ActiveRecord.setCurrentUser(res);

                        Log.v("TWITTER", response.toString());


                        Intent mainActivity = new Intent(getApplicationContext(), MainActivity.class);
                        startActivity(mainActivity);

                        finish();
                    }
                });
            }

            @Override
            public void failure(TwitterException exception) {
                // Do something on failure
            }
        });


    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
        loginTwitter.onActivityResult(requestCode, resultCode, data);
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
