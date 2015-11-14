package com.soonzik.soonzik;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;


public class UserPageActivity extends Activity {

    Button updateUserButton;
    Button playlistsUserButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.fragment_profile);

        Intent intent = getIntent();

        final int id = intent.getIntExtra("userId", -1);

        try {
            ActiveRecord.show("User", id, new ActiveRecord.OnJSONResponseCallback() {

                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
                    JSONObject obj = (JSONObject) response;

                    User res = (User) ActiveRecord.jsonObjectData(obj, classT);

                    ((TextView) findViewById(R.id.emailUser)).setText(res.getEmail());
                    ((TextView) findViewById(R.id.lnameUser)).setText(res.getLname());
                    ((TextView) findViewById(R.id.fnameUser)).setText(res.getFname());
                    ((TextView) findViewById(R.id.usernameUser)).setText(res.getUsername());
                    ((TextView) findViewById(R.id.birthdayUser)).setText(res.getBirthday());
                    ((TextView) findViewById(R.id.imageUser)).setText(res.getImage());
                    ((TextView) findViewById(R.id.descriptionUser)).setText(res.getDescription());
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        updateUserButton = (Button) findViewById(R.id.updateUserButton);
        updateUserButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent updateUserActivity = new Intent(getApplicationContext(), UpdateUserActivity.class);

                updateUserActivity.putExtra("userId", id);
                startActivity(updateUserActivity);
            }
        });

        playlistsUserButton = (Button) findViewById(R.id.playlistsUserButton);
        playlistsUserButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent playlistsActivity = new Intent(getApplicationContext(), PlaylistsActivity.class);

                playlistsActivity.putExtra("userId", id);
                startActivity(playlistsActivity);
            }
        });

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_user_page, menu);
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
