package com.soonzik.soonzik;

import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;


public class PlaylistsActivity extends ActionBarActivity {

    TextView playlistName;
    Button deletePlaylistButtom;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_playlists);

        Intent intent = getIntent();

        final int id = intent.getIntExtra("userId", -1);
        Map<String, String> tmp = new HashMap<String, String>();

        tmp.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
        tmp.put("name", "Test Playlist");
        ActiveRecord.save("Playlist", tmp, new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
                JSONObject obj = (JSONObject) response;

                final Playlist playlist = (Playlist) ActiveRecord.jsonObjectData(obj, classT);
                playlistName = (TextView) findViewById(R.id.playlistName);
                playlistName.setText(playlist.getName());
                deletePlaylistButtom = (Button) findViewById(R.id.deletePlaylistButtom);

                deletePlaylistButtom.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        ActiveRecord.destroy("Playlist", playlist.getId(), new ActiveRecord.OnJSONResponseCallback() {
                            @Override
                            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException {
                                Log.v("DESTROY PLAYLIST", "C'est OK");
                            }
                        });
                    }
                });
            }
        });

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_playlists, menu);
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
