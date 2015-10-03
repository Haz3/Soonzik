package com.soonzik.soonzik;

import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import org.apache.http.Header;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 13/03/2015.
 */

public class User extends ActiveRecord {
    private int id = -1;

    private String email = "";
    private String fname = "";
    private String lname = "";
    private String username = "";
    private String birthday = "";
    private String image = "";
    private String background = "";
    private String description = "";
    private String facebook = "";
    private String twitter = "";
    private String googlePlus = "";
    private String language = "";
    private String phoneNumber = "";
    private Address address = null;
    private boolean newsletter = false;
    private ArrayList<User> follows = null;
    private ArrayList<User> friends = null;

    private MyContent content = null;

    private String secureKey = "";
    private String idAPI = "";
    private String salt = "";

    private Date created_at = null;
    private Date updated_at = null;

    public interface OnJSONResponseCallback {
        public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException, IOException;
    }

    public User (String objStr) throws JSONException {
        JSONObject obj = new JSONObject(objStr);
        tmp(obj);
        Log.v("USER", this.toString());
    }

    public User() {}

    public User(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    private void tmp (JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public String getUserSecureKey(final RequestParams params, final OnJSONResponseCallback callback) {
        AsyncHttpClient client = new AsyncHttpClient();
        ActiveRecord.userId = this.id;

        client.get("http://10.0.3.2:3000/api/getKey/" + Integer.toString(this.id), new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                Log.v("SECURERESP1", response.toString());
                try {
                    //JSONObject obj = response.getJSONObject("content");
                    Log.v("SECURERESP", response.toString());

                    callback.onJSONResponse(true, response, params);
                    /*secureKey = response.getString("key");
                    ActiveRecord.secureKey = response.getString("key");*/
                } catch (JSONException e) {
                    e.printStackTrace();
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                Log.v("FAIL", response.toString());
            }

        });
        return secureKey;
    }

    public static void getMusics(final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.get("http://10.0.3.2:3000/api/users/getmusics", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "MyContent");
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

    public static void follow(int id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("follow_id", Integer.toString(id));
        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.post("http://10.0.3.2:3000/api/users/follow", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "User");
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

    public static void unfollow(int id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("follow_id", Integer.toString(id));
        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.post("http://10.0.3.2:3000/api/users/unfollow", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "User");
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

    public static void addFriend(int id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("friend_id", Integer.toString(id));
        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.post("http://10.0.3.2:3000/api/users/addfriend", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "User");
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

    public static void delFriend(int id, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("friend_id", Integer.toString(id));
        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(ActiveRecord.currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.post("http://10.0.3.2:3000/api/users/delfriend", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "User");
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

    public static void getFriends(int id, final ActiveRecord.OnJSONResponseCallback callback) {
        AsyncHttpClient client = new AsyncHttpClient();

        client.get("http://10.0.3.2:3000/api/users/" + Integer.toString(id) + "/friends", new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                Log.v("JSON getFriends", response.toString());
                try {
                    final Class<?> classT = Class.forName("com.soonzik.soonzik." + "User");
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

    public static void getFollows(int id, final ActiveRecord.OnJSONResponseCallback callback) {
        AsyncHttpClient client = new AsyncHttpClient();

        client.get("http://10.0.3.2:3000/api/users/" + Integer.toString(id) + "/follows", new JsonHttpResponseHandler(){
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                Log.v("JSON", response.toString());
                try {
                    final Class<?> classT = Class.forName("com.soonzik.soonzik." + "User");
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

    public static void getFollowers(int id, final ActiveRecord.OnJSONResponseCallback callback) {
        AsyncHttpClient client = new AsyncHttpClient();

        client.get("http://10.0.3.2:3000/api/users/" + Integer.toString(id) + "/followers", new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                Log.v("JSON", response.toString());
                try {
                    final Class<?> classT = Class.forName("com.soonzik.soonzik." + "User");
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

    public static void uploadImg(String content_type, String filename, String tempfile, String type, final ActiveRecord.OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();
        Map<String, String> paramList = new HashMap<String, String>();

        if (!type.equals("")) {
            params.put("type", type);
        }

        paramList.put("content_type", content_type);
        paramList.put("original_filename", filename);
        paramList.put("tempfile", tempfile);

        params.put("file", paramList);
        ActiveRecord.currentUser.getUserSecureKey(params, new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                AsyncHttpClient client = new AsyncHttpClient();

                client.post("http://10.0.3.2:3000/api/users/upload", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik." + "User");
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

    static void getSocialToken(String uid, String provider, final OnJSONResponseCallback callback) {
        AsyncHttpClient client = new AsyncHttpClient();

        client.get("http://10.0.3.2:3000/api/getSocialToken/" + uid + "/" + provider, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                try {
                    callback.onJSONResponse(true, response, null);
                } catch (JSONException e) {
                    e.printStackTrace();
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                Log.v("FAIL", response.toString());
            }
        });
    }

    public static void socialLogin(final String uid, final String provider, final String socialtoken, final ActiveRecord.OnJSONResponseCallback callback) {
        final String salt = "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E";

        getSocialToken(uid, provider, new OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException, IOException {
                AsyncHttpClient client = new AsyncHttpClient();
                RequestParams p = new RequestParams();

                p.put("uid", uid);
                p.put("provider", provider);

                String toHash = uid + response.getString("key") + salt;
                MessageDigest digest = MessageDigest.getInstance("SHA-256");
                byte[] hash = digest.digest(toHash.getBytes("UTF-8"));
                StringBuffer hexString = new StringBuffer();

                for (int i = 0; i < hash.length; i++) {
                    String hex = Integer.toHexString(0xff & hash[i]);
                    if(hex.length() == 1) hexString.append('0');
                    hexString.append(hex);
                }

                p.put("encrypted_key", hexString);
                p.put("token", socialtoken);
                client.post("http://10.0.3.2:3000/api/social-login", p, new JsonHttpResponseHandler() {
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.soonzik.User");
                            JSONObject obj = response.getJSONObject("content");
                            Log.v("SOCIAL LOGIN JSON", obj.toString());

                            callback.onJSONResponse(true, obj, classT);
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
        String str = "id = " + Integer.toString(id)
                        + " : secureKey = " + secureKey
                        + " : idAPI = " + idAPI
                        + " : email = " + email
                        + " : username = " + username
                        + " : birthday = " + birthday
                        + " : image = " + image
                        + " : background = " + background
                        + " : description = " + description
                        + " : language = " + language
                        + " : fname = " + fname
                        + " : lname = " + lname
                        + " : phoneNumber = " + phoneNumber
                        + " : facebook = " + facebook
                        + " : twitter = " + twitter
                        + " : googlePlus = " + googlePlus
                        + " : Adress = { " + (address != null ? address.toString() : "") + " }"
                        + " : salt = " + salt
                        + " : newsletter = " + Boolean.toString(newsletter)
                        + " : created_at = " + (created_at != null ? created_at.toString() : "")
                        + " : updated_at = " + (updated_at != null ? updated_at.toString() : "");
        str += " : follows = [ ";
        if (follows != null) {
            for (User follow : follows) {
                str += "{ " + follow.toString() +  " } ";
            }
        }
        str += " ]";
        str += " : friends = [ ";
        if (friends != null) {
            for (User friend : friends) {
                str += "{ " + friend.toString() +  " } ";
            }
        }
        str += " ]";
        return (str);
    }


    public int getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getFname() {
        return fname;
    }

    public String getLname() {
        return lname;
    }

    public String getUsername() {
        return username;
    }

    public String getBirthday() {
        return birthday;
    }

    public String getImage() {
        return image;
    }

    public String getBackground() { return background; }

    public String getDescription() {
        return description;
    }

    public String getFacebook() {
        return facebook;
    }

    public String getTwitter() {
        return twitter;
    }

    public String getGooglePlus() {
        return googlePlus;
    }

    public String getLanguage() {
        return language;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public Address getAddress() {
        return address;
    }

    public boolean isNewsletter() {
        return newsletter;
    }

    public ArrayList<User> getFollows() {
        return follows;
    }

    public ArrayList<User> getFriends() {
        return friends;
    }

    public String getSecureKey() {
        return secureKey;
    }

    public String getIdAPI() {
        return idAPI;
    }

    public String getSalt() {
        return salt;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public Date getUpdated_at() {
        return updated_at;
    }

    public void setFollows(ArrayList<User> follows) {
        this.follows = follows;
    }

    public void setFriends(ArrayList<User> friends) {
        this.friends = friends;
    }

    public void setContent(MyContent content) {
        this.content = content;
    }

    public MyContent getContent() {
        return this.content;
    }
}
