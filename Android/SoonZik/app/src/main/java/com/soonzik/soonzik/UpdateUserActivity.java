package com.soonzik.soonzik;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;


public class UpdateUserActivity extends Activity {

    Button updateValidateButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_update_user);
        Intent intent = getIntent();
        final Activity those = this;

        final int id = intent.getIntExtra("userId", -1);
        try {
            ActiveRecord.show("User", id, new ActiveRecord.OnJSONResponseCallback() {

                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
                    JSONObject obj = (JSONObject) response;

                    User res = (User) ActiveRecord.jsonObjectData(obj, classT);

                    ((EditText) findViewById(R.id.emailUpdateInput)).setText(res.getEmail());
                    ((EditText) findViewById(R.id.lnameUpdateInput)).setText(res.getLname());
                    ((EditText) findViewById(R.id.fnameUpdateInput)).setText(res.getFname());
                    ((EditText) findViewById(R.id.usernameUpdateInput)).setText(res.getUsername());
                    ((EditText) findViewById(R.id.birthdayUpdateInput)).setText(res.getBirthday());
                    ((EditText) findViewById(R.id.languageUpdateInput)).setText(res.getLanguage());
                    ((EditText) findViewById(R.id.descriptionUpdateInput)).setText(res.getDescription());
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        updateValidateButton = (Button) findViewById(R.id.updateValidateButton);
        updateValidateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Map<String, String> params = new HashMap<String, String>();

                params.put("email", ((EditText) findViewById(R.id.emailUpdateInput)).getText().toString());
                params.put("lname", ((EditText) findViewById(R.id.lnameUpdateInput)).getText().toString());
                params.put("fname", ((EditText) findViewById(R.id.fnameUpdateInput)).getText().toString());
                params.put("username", ((EditText) findViewById(R.id.usernameUpdateInput)).getText().toString());
                params.put("birthday", ((EditText) findViewById(R.id.birthdayUpdateInput)).getText().toString());
                params.put("language", ((EditText) findViewById(R.id.languageUpdateInput)).getText().toString());
                params.put("description", ((EditText) findViewById(R.id.descriptionUpdateInput)).getText().toString());

                try {
                    ActiveRecord.update("User", params, new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
                            JSONObject obj = (JSONObject) response;

                            User res = (User) ActiveRecord.jsonObjectData(obj, classT);
                            Intent userPage = new Intent(getApplicationContext(), UserPageActivity.class);

                            userPage.putExtra("userId", res.getId());
                            //startActivity(userPage);
                            Toast t = Toast.makeText(getApplicationContext(), "Your informations are update with success", Toast.LENGTH_LONG);
                            t.show();
                            those.finish();
                        }
                    });
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_update_user, menu);
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
