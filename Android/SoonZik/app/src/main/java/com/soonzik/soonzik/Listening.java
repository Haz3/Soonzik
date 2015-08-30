package com.soonzik.soonzik;

import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;

import org.apache.http.Header;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Listening extends ActiveRecord {
    private Music music = null;
    private Date when = null;
    private double latitude = 0;
    private double longitude = 0;
    private User user = null;

    public Listening() {}

    public Listening(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public static void arroundMe(double latitude, double longitude, int range, final OnJSONResponseCallback callback) throws ClassNotFoundException {
        final String className = "Listening";
        final Class<?> classT = Class.forName("com.soonzik.soonzik." + className);

        AsyncHttpClient client = new AsyncHttpClient();
        char lastChar = className.charAt(className.length() - 1);
        client.get("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "/" : "s/") + "around/" + Double.toString(latitude) + "/" + Double.toString(longitude) + "/" + Integer.toString(range), new JsonHttpResponseHandler() {

            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                try {
                    JSONObject obj = response.getJSONObject("content");
                    Log.v("AROUND JSON", obj.toString());

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
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                Log.v("FAIL", response.toString());
            }

        });
    }

    @Override
    public String toString() {
        return (
                "Music = { " + (music != null ? music.toString() : "") + " }"
                + " : when = " + (when != null ? when.toString() : "")
                + " : latitude = " + Double.toString(latitude)
                + " : longitude = " + Double.toString(longitude)
                );
    }

    public Music getMusic() {
        return music;
    }

    public Date getWhen() {
        return when;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public User getUser() {
        return user;
    }
}
