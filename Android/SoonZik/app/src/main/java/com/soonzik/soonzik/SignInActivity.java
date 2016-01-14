package com.soonzik.soonzik;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;


public class SignInActivity extends Activity {

    Button signinButtonRegister;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_in);

        signinButtonRegister = (Button) findViewById(R.id.signinButtonRegister);
        signinButtonRegister.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Map<String, String> params = new HashMap<String, String>();

                params.put("email", ((EditText) findViewById(R.id.emailSigninInput)).getText().toString());
                params.put("fname", ((EditText) findViewById(R.id.firstnameSigninInput)).getText().toString());
                params.put("lname", ((EditText) findViewById(R.id.lastnameSigninInput)).getText().toString());
                params.put("username", ((EditText) findViewById(R.id.usernameSigninInput)).getText().toString());
                params.put("password", ((EditText) findViewById(R.id.passwordSigninInput)).getText().toString());
                params.put("birthday", ((EditText) findViewById(R.id.birthdaySigninInput)).getText().toString() + " 00:00:01");
                params.put("language", ((EditText) findViewById(R.id.languageSigninInput)).getText().toString());

                ActiveRecord.save("User", params, new ActiveRecord.OnJSONResponseCallback() {

                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
                        Intent loginPageActivity = new Intent(getApplicationContext(), MainActivity.class);
                        startActivity(loginPageActivity);
                    }
                });
                finish();
            }
        });
    }
}
