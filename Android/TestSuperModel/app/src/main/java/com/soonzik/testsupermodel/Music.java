package com.soonzik.testsupermodel;

import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 13/03/2015.
 */

public class Music extends ActiveRecord {

    private int id = -1;
    private String title = "";
    private int duration = -1;
    private double price = -1;
    private String file = "";
    private User user = null;
    private ArrayList<Genre> genres = null;
    private Album album = null;
    private boolean limited = true;

    public Music() {}

    public Music(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public void addToPlaylist(int id, int playlist_id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("id", Integer.toString(id));
        params.put("playlist_id", Integer.toString(playlist_id));
        ActiveRecord.currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                AsyncHttpClient client = new AsyncHttpClient();

                client.post("http://10.0.3.2:3000/api/musics/addtoplaylist", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + "Music");
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
        });
    }

    public void get(final int id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        ActiveRecord.currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                AsyncHttpClient client = new AsyncHttpClient();

                client.get("http://10.0.3.2:3000/api/musics/get/" + Integer.toString(id), params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        /*try {
                            final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + "Music");
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
                        }*/
                    }

                    @Override
                    public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                        Log.v("FAIL", response.toString());
                    }
                });
            }
        });
    }

    @Override
    public String toString() {
        return ("id = " + Integer.toString(id)
                + " : title = " + title
                + " : duration = " + Integer.toString(duration)
                + " : price = " + Double.toString(price)
                + " : file = " + file
                + " : limited = " + Boolean.toString(limited)
                + " : User = { " + (user != null ? user.toString() : "") + " }"
                + " : Genres = { " + (genres != null ? genres.toString() : "") + " }"
                + " : Album = { " + (album != null ? album.toString() : "") + " }");
    }


    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public int getDuration() {
        return duration;
    }

    public double getPrice() {
        return price;
    }

    public String getFile() {
        return file;
    }

    public User getUser() {
        return user;
    }

    public ArrayList<Genre> getGenres() {
        return genres;
    }

    public Album getAlbum() {
        return album;
    }

    public boolean isLimited() {
        return limited;
    }


}
