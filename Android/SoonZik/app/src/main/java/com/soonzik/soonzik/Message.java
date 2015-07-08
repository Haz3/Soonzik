package com.soonzik.soonzik;

import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Message extends ActiveRecord {
    private int id = -1;
    private String msg = null;
    private int dest_id = -1;
    private int user_id = -1;

    public Message() {}

    public Message(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : msg = " + msg
                + " : dest_id = " + Integer.toString(dest_id)
                + " : user_id = " + Integer.toString(user_id)
                );
    }

    public static void conversation(final int userId, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {

            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.get("http://10.0.3.2:3000/api/messages/conversation/" + Integer.toString(userId), params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "Message");
                            JSONArray obj = response.getJSONArray("content");

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

    public int getId() {
        return id;
    }

    public String getMsg() {
        return msg;
    }

    public int getDest_id() {
        return dest_id;
    }

    public int getUser_id() {
        return user_id;
    }
}
