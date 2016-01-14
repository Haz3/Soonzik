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
import java.util.Date;
import java.util.HashMap;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Purchase extends ActiveRecord {
    private int id = -1;
    private User user = null;
    private Date created_at = null;

    public Purchase() {}

    public Purchase(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }


    public static void buyCart(HashMap<String, String> paypal, final OnJSONResponseCallback callback) {
        final String className = "Purchase";
        RequestParams params = new RequestParams();

        params.put("paypal", paypal);
        currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                char lastChar = className.charAt(className.length() - 1);
                Log.v("BUYCART", ActiveRecord.serverLink + className.toLowerCase() + (lastChar == 's' ? "/buycart" : "s/buycart"));
                Log.v("BUYCART", params.toString());
                client.post(ActiveRecord.serverLink + className.toLowerCase() + (lastChar == 's' ? "/buycart" : "s/buycart"), params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        //Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + className);

                            JSONObject obj = response.getJSONObject("content");
                            Log.v("SAVE JSON", obj.toString());

                            callback.onJSONResponse(true, obj, classT);
                            User.getMusics(new ActiveRecord.OnJSONResponseCallback() {
                                @Override
                                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                                    JSONObject data = (JSONObject) response;
                                    final MyContent ct = (MyContent) ActiveRecord.jsonObjectData(data, classT);

                                    ActiveRecord.currentUser.setContent(ct);
                                }
                            });
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
                        Log.v("FAIL", e.toString());
                        Log.v("FAIL", Integer.toString(statusCode));
                    }
                });
            }
        });
    }

    public static void buyPack(int pack_id, float amount, int artist, int association, int website, HashMap<String, String> paypal, int gift_id, final OnJSONResponseCallback callback) {
        final String className = "Purchase";
        RequestParams params = new RequestParams();

        params.put("pack_id", Integer.toString(pack_id));
        params.put("amount", Float.toString(amount));
        params.put("artist", Integer.toString(artist));
        params.put("association", Integer.toString(association));
        params.put("website", Integer.toString(website));
        params.put("paypal", paypal);

        Log.v("gift_user_id_1", Integer.toString(gift_id));

        if (gift_id != -1) {
            params.put("gift_user_id", gift_id);
        }

        Log.v("PURCHASE", params.toString());

        currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                char lastChar = className.charAt(className.length() - 1);
                client.post(ActiveRecord.serverLink + className.toLowerCase() + (lastChar == 's' ? "/buypack" : "s/buypack"), params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + className);

                            JSONObject obj = response.getJSONObject("content");
                            Log.v("SAVE JSON", obj.toString());

                            callback.onJSONResponse(true, obj, classT);
                            User.getMusics(new ActiveRecord.OnJSONResponseCallback() {
                                @Override
                                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                                    JSONObject data = (JSONObject) response;
                                    final MyContent ct = (MyContent) ActiveRecord.jsonObjectData(data, classT);

                                    ActiveRecord.currentUser.setContent(ct);
                                }
                            });
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
                 + " : User = { " + (user != null ? user.toString() : "") + " }"
                 + " : created_at = " + (created_at != null ? created_at.toString() : "")
        );
    }

}
