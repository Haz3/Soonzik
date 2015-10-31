package com.soonzik.soonzik;

import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Battle extends ActiveRecord {
    private int id = -1;
    private Date date_begin = null;
    private Date date_end = null;
    private User artist_one = null;
    private User artist_two = null;
    private ArrayList<Vote> votes = null;

    public Battle() {}

    public Battle(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public static void vote(final int id, int artist_id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("artist_id", Integer.toString(artist_id));
        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.post(ActiveRecord.serverLink + "battles/" + Integer.toString(id) + "/vote", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "Battle");
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

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                        + " : date_begin = " + (date_begin != null ? date_begin.toString() : "")
                        + " : date_end = " + (date_end != null ? date_end.toString() : "")
                        + " : artist_one = { " + (artist_one != null ? artist_one.toString() : "") + " }"
                        + " : artist_two = { " + (artist_two != null ? artist_two.toString() : "") + " }"
                        + " : user_vote = { " + (votes != null ? votes.toString() : "") + " }"
        );
    }

    public User getArtistOne() {
        return artist_one;
    }

    public User getArtistTwo() {
        return artist_two;
    }

    public int getId() {
        return id;
    }

    public ArrayList<Vote> getVotes() {
        return votes;
    }

    public Date getDate_begin() {
        return date_begin;
    }

    public Date getDate_end() {
        return date_end;
    }
}
