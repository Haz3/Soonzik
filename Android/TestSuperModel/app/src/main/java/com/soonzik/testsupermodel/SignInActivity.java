package com.soonzik.testsupermodel;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

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
                params.put("username", ((EditText) findViewById(R.id.usernameSigninInput)).getText().toString());
                params.put("password", ((EditText) findViewById(R.id.passwordSigninInput)).getText().toString());
                params.put("birthday", ((EditText) findViewById(R.id.birthdaySigninInput)).getText().toString());
                params.put("language", ((EditText) findViewById(R.id.languageSigninInput)).getText().toString());

                ActiveRecord.save("User", params, false, new ActiveRecord.OnJSONResponseCallback() {

                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
                        Intent loginPageActivity = new Intent(getApplicationContext(), MainActivity.class);
                        startActivity(loginPageActivity);
                        Toast t = Toast.makeText(getApplicationContext(), "You are successfull registed", Toast.LENGTH_LONG);
                        t.show();
                    }
                });
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_sign_in, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
