package com.soonzik.soonzik;

import android.net.Uri;
import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.FileAsyncHttpResponseHandler;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
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
    private ArrayList<Description> descriptions = null;

    public Music() {}

    public Music(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public static void addToPlaylist(int id, int playlist_id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("id", Integer.toString(id));
        params.put("playlist_id", Integer.toString(playlist_id));
        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.post("http://10.0.3.2:3000/api/musics/addtoplaylist", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "Music");
                            JSONArray data = response.getJSONArray("content");

                            callback.onJSONResponse(true, data, classT);
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

    public static void delFromPlaylist(int id, int playlist_id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("id", Integer.toString(id));
        params.put("playlist_id", Integer.toString(playlist_id));
        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.post("http://10.0.3.2:3000/api/musics/delfromplaylist", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "Music");
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

    public static void get(final int id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, IOException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                File f = File.createTempFile("temp_", "_handled");

                client.get("http://10.0.3.2:3000/api/musics/get/" + Integer.toString(id), params, new FileAsyncHttpResponseHandler(f) {
                    @Override
                    public void onFailure(int i, Header[] headers, Throwable throwable, File file) {
                        Log.v("FAIL", "Oups");
                    }

                    @Override
                    public void onSuccess(int i, Header[] headers, File file) {
                        Uri uri = Uri.parse(file.toString());

                        try {
                            callback.onJSONResponse(true, uri, null);
                        } catch (InvocationTargetException e) {
                            e.printStackTrace();
                        } catch (NoSuchMethodException e) {
                            e.printStackTrace();
                        } catch (InstantiationException e) {
                            e.printStackTrace();
                        } catch (IllegalAccessException e) {
                            e.printStackTrace();
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                });

                /*client.get("http://10.0.3.2:3000/api/musics/get/" + Integer.toString(id), params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        //Log.v("JSON", response.toString());

                        Uri uri = Uri.parse(response.toString());

                        try {
                            callback.onJSONResponse(true, uri, null);
                        } catch (InvocationTargetException e) {
                            e.printStackTrace();
                        } catch (NoSuchMethodException e) {
                            e.printStackTrace();
                        } catch (InstantiationException e) {
                            e.printStackTrace();
                        } catch (IllegalAccessException e) {
                            e.printStackTrace();
                        }

                    }

                    @Override
                    public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                        Log.v("FAIL", response.toString());
                    }
                });*/
            }
        });
    }

    public static void getSecureUrl(final int id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, IOException, NoSuchAlgorithmException {
                String secureUrl = "http://10.0.3.2:3000/api/musics/get/" + Integer.toString(id) + "?user_id=" + Integer.toString(ActiveRecord.currentUser.getId()) + "&secureKey=" + ActiveRecord.currentUser.getSecureKey();

                try {
                    callback.onJSONResponse(true, secureUrl, null);
                } catch (InvocationTargetException e) {
                    e.printStackTrace();
                } catch (NoSuchMethodException e) {
                    e.printStackTrace();
                } catch (InstantiationException e) {
                    e.printStackTrace();
                } catch (IllegalAccessException e) {
                    e.printStackTrace();
                }
            }
        });
    }

    @Override
    public String toString() {
        String str = "";
        str += "id = " + Integer.toString(id)
                + " : title = " + title
                + " : duration = " + Integer.toString(duration)
                + " : price = " + Double.toString(price)
                + " : file = " + file
                + " : limited = " + Boolean.toString(limited)
                + " : User = { " + (user != null ? user.toString() : "") + " }"
                + " : Genres = { " + (genres != null ? genres.toString() : "") + " }"
                + " : Album = { " + (album != null ? album.toString() : "") + " }";

        str += " : Description = [ ";
        if (descriptions != null) {
            for (Description description: descriptions) {
                str += "{ " + description.toString() + " } ";
            }
        }
        str += " ]";

        return (str);
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

    public void setUser(User user) {
        this.user = user;
    }
}
