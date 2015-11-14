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
import java.util.ArrayList;
import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Cart extends ActiveRecord {
    private int id = -1;
    private ArrayList<Music> musics = null;
    private ArrayList<Album> albums = null;
    private Date created_at = null;
    private Gift gift = null;

    public Cart() {}

    public Cart(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public static void myCart(final OnJSONResponseCallback callback) throws ClassNotFoundException {
        final String className = "Cart";
        final Class<?> classT = Class.forName("com.soonzik.soonzik." + className);

        RequestParams params = new RequestParams();
        currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();
                char lastChar = className.charAt(className.length() - 1);
                client.get(ActiveRecord.serverLink + className.toLowerCase() + (lastChar == 's' ? "/" : "s/") + "my_cart", params, new JsonHttpResponseHandler() {

                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        try {
                            JSONArray obj = response.getJSONArray("content");
                            Log.v("MYCART JSON", obj.toString());

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
        });
    }

    public static void giftCart(final int id_cart, int user_gift_id, final OnJSONResponseCallback callback) throws ClassNotFoundException {
        final String className = "Cart";
        final Class<?> classT = Class.forName("com.soonzik.soonzik." + className);

        RequestParams params = new RequestParams();
        params.add("user_gift_id", Integer.toString(user_gift_id));
        currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();
                char lastChar = className.charAt(className.length() - 1);
                client.post(ActiveRecord.serverLink + className.toLowerCase() + (lastChar == 's' ? "/" : "s/") + Integer.toString(id_cart) + "/gift", params, new JsonHttpResponseHandler() {

                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        try {
                            JSONObject obj = response.getJSONObject("content");
                            Log.v("GIFTCART JSON", obj.toString());

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
        });
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : musics = { " + (musics != null ? musics.toString() : "") + " }"
                + " : albums = { " + (albums != null ? albums.toString() : "") + " }"
                + " : date = " + (created_at != null ? created_at.toString() : "")
                + " : gift = " + (gift != null ? gift.toString() : "")
                );
    }

    public int getId() {
        return id;
    }

    public ArrayList<Music> getMusics() {
        return musics;
    }

    public ArrayList<Album> getAlbums() {
        return albums;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public Gift getGift() {
        return gift;
    }
}
