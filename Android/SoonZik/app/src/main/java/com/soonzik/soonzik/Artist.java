package com.soonzik.soonzik;

import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;

import org.apache.http.Header;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 08/07/2015.
 */
public class Artist extends ActiveRecord {

    private Boolean artist = false;
    private ArrayList<Album> albums = null;
    private ArrayList<Music> topFive = null;

    public Artist() {}

    public Artist(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public Boolean getArtist() {
        return artist;
    }

    public ArrayList<Album> getAlbums() {
        return albums;
    }

    public ArrayList<Music> getTopFive() {
        return topFive;
    }

    public static void isArtist(int id, final ActiveRecord.OnJSONResponseCallback callback) {
        AsyncHttpClient client = new AsyncHttpClient();

        client.get(ActiveRecord.serverLink + "users/" + Integer.toString(id) + "/isartist", new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                Log.v("JSON", response.toString());
                try {
                    final Class<?> classT = Class.forName("com.soonzik.soonzik." + "Artist");
                    JSONObject obj = response.getJSONObject("content");

                    callback.onJSONResponse(true, obj, classT);
                } catch (JSONException e) {
                    e.printStackTrace();
                } catch (NoSuchMethodException e) {
                    e.printStackTrace();
                } catch (InstantiationException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                Log.v("FAIL", response.toString());
            }
        });
    }
}
