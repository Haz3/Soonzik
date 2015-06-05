package com.soonzik.testsupermodel;

import android.annotation.TargetApi;
import android.os.Build;
import android.util.Log;
import android.util.Pair;

import com.loopj.android.http.*;

import org.apache.http.Header;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.mindrot.jbcrypt.BCrypt;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;

import java.lang.reflect.*;
import java.util.Map;

/**
 * Created by kevin_000 on 13/03/2015.
 */



public class ActiveRecord {
    static User currentUser;
    static int userId = -1;
    static String secureKey = "";

    public interface OnJSONResponseCallback {
        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException;
    }

    public static ArrayList<Object> jsonArrayData(JSONArray data, Class<?> classT) throws NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {
        final ArrayList<Object> objectList = new ArrayList<Object>();
        for (int i = 0; i < data.length(); i++) {
            JSONObject obj =  data.optJSONObject(i);
            Constructor constructor = classT.getDeclaredConstructor(JSONObject.class);
            constructor.setAccessible(true);
            objectList.add(constructor.newInstance(obj));
        }
        for (int x = 0; x < objectList.size(); x++) {
            //Log.v("TRY", Integer.toString(x));
            Log.v("INDEX || FIND", objectList.get(x).toString());
        }
        return objectList;
    }

    public static Object jsonObjectData(JSONObject obj, Class<?> classT) throws NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException {
        final Object[] object = {null};

        Constructor constructor = classT.getDeclaredConstructor(JSONObject.class);
        constructor.setAccessible(true);
        object[0] = constructor.newInstance(obj);
        return object[0];
    }

    public static void index(String className, final OnJSONResponseCallback callback) throws ClassNotFoundException {

        final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);

        AsyncHttpClient client = new AsyncHttpClient();
        ;
        char lastChar = className.charAt(className.length() - 1);
        client.get("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "" : "s"), new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                try {
                    JSONArray data = response.getJSONArray("content");
                    Log.v("INDEX JSON", data.toString());

                    callback.onJSONResponse(true, data, classT);
                } catch (JSONException | InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
                    e.printStackTrace();
                }
            }
            @Override
            public void onFailure(int statusCode, Header[]headers, Throwable e, JSONObject response) {
                Log.v("FAIL", response.toString());
            }

        });
    }

    public static void show(final String className, final int id, boolean secureMode, final OnJSONResponseCallback callback) throws ClassNotFoundException {

        final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);

        if (secureMode) {
            RequestParams params = new RequestParams();
            currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                    ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                    AsyncHttpClient client = new AsyncHttpClient();
                    char lastChar = className.charAt(className.length() - 1);
                    client.get("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "/" : "s/") + Integer.toString(id), params, new JsonHttpResponseHandler() {

                        @Override
                        public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                            try {
                                JSONObject obj = response.getJSONObject("content");
                                Log.v("SHOW JSON", obj.toString());

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
        else {
            AsyncHttpClient client = new AsyncHttpClient();
            char lastChar = className.charAt(className.length() - 1);
            client.get("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "/" : "s/") + Integer.toString(id), new JsonHttpResponseHandler() {

                @Override
                public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                    try {
                        JSONObject obj = response.getJSONObject("content");
                        Log.v("SHOW JSON", obj.toString());

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
    }

    public static void find(String className, Map<String, Object> paramsFind, boolean secureMode, final OnJSONResponseCallback callback) throws ClassNotFoundException {

        final ArrayList<Object> objectList = new ArrayList<Object>();
        final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);

        char lastChar = className.charAt(className.length() - 1);
        String linkParam = className.toLowerCase() + (lastChar == 's' ? "/find?" : "s/find?");
        ArrayList<Pair<String, String>> paramList = Utils.formatURL(paramsFind);
        for (int i = 0; i < paramList.size(); i++) {
            linkParam += paramList.get(i).first + "=" + paramList.get(i).second;
            if ((i + 1) < paramList.size()) {
                linkParam += "&";
            }
        }
        Log.v("FIND PARAMS", linkParam);

        if (secureMode) {
            RequestParams params = new RequestParams();
            final String finalLinkParam = linkParam;
            currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                    ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                    AsyncHttpClient client = new AsyncHttpClient();
                    client.get("http://10.0.3.2:3000/api/" + finalLinkParam, new JsonHttpResponseHandler() {
                        @Override
                        public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                            try {
                                JSONArray data = response.getJSONArray("content");
                                Log.v("FIND JSON", data.toString());

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
        else {
            AsyncHttpClient client = new AsyncHttpClient();
            client.get("http://10.0.3.2:3000/api/" + linkParam, new JsonHttpResponseHandler() {
                @Override
                public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                    try {
                        JSONArray data = response.getJSONArray("content");
                        Log.v("FIND JSON", data.toString());

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
                    }
                }

                @Override
                public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                    Log.v("FAIL", response.toString());
                }
            });
        }
    }

    public static void save(final String className, Map<String, String> data, boolean secureMode, final OnJSONResponseCallback callback) {

        RequestParams params = new RequestParams();
        Map<String, String> paramList = new HashMap<String, String>();

        for (Map.Entry<String, String> entry : data.entrySet()) {
            paramList.put(entry.getKey(), entry.getValue());
        }
        params.put(className.toLowerCase(), paramList);

        if (secureMode) {
            currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                    ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                    AsyncHttpClient client = new AsyncHttpClient();

                    char lastChar = className.charAt(className.length() - 1);
                    client.post("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "/save" : "s/save"), params, new JsonHttpResponseHandler() {
                        @Override
                        public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                            //Log.v("JSON", response.toString());
                            try {
                                final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);

                                JSONObject obj = response.getJSONObject("content");
                                Log.v("SAVE JSON", obj.toString());

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
        else {
            AsyncHttpClient client = new AsyncHttpClient();
            char lastChar = className.charAt(className.length() - 1);
            client.post("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "/save" : "s/save"), params, new JsonHttpResponseHandler() {
                @Override
                public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                    //Log.v("JSON", response.toString());
                    try {
                        final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);

                        JSONObject obj = response.getJSONObject("content");
                        Log.v("SAVE JSON", obj.toString());

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

    public static void update(final String className, Map<String, String> data, int id, final OnJSONResponseCallback callback) throws UnsupportedEncodingException, NoSuchAlgorithmException, JSONException {

        RequestParams params = new RequestParams();
        Map<String, String> paramList = new HashMap<String, String>();

        for (Map.Entry<String, String> entry : data.entrySet()) {
            paramList.put(entry.getKey(), entry.getValue());
        }
        params.put(className.toLowerCase(), paramList);

        currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {

            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                char lastChar = className.charAt(className.length() - 1);
                client.post("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "/update" : "s/update"), params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON", response.toString());
                        try {
                            final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);
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

    public static void destroy(final String className, final int id, final OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {

            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();
                params.put("id", id);
                char lastChar = className.charAt(className.length() - 1);
                client.get("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "/destroy" : "s/destroy"), params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON DESTROY", response.toString());
                        /*
                            final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);
                            JSONObject obj = response.getJSONObject("content");

                            callback.onJSONResponse(true, obj, classT);
                         */
                    }

                    @Override
                    public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                        Log.v("FAIL", response.toString());
                    }
                });
            }
        });
    }

    public static void search(int offset, int limit, String query, String type, final OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();
        Map<String, String> paramList = new HashMap<String, String>();

        AsyncHttpClient client = new AsyncHttpClient();
        if (!query.equals("")) {
            params.put("query", query);
        }
        if (offset >= 0) {
            params.put("offset", Integer.toString(offset));
        }
        if (limit > 0) {
            params.put("limit", Integer.toString(limit));
        }
        if (!type.equals("")) {
            params.put("type", type);
        }

        client.get("http://10.0.3.2:3000/api/" + "search", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                Log.v("JSON search", response.toString());
                try {
                    final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + "Search");
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

    public static void suggest(final int id, final OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("id", id);

        currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {

            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();

                client.get("http://10.0.3.2:3000/api/" + "suggest", params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON SUGGEST", response.toString());

                        try {
                            final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + "Music");
                            JSONArray obj = response.getJSONArray("content");
                            callback.onJSONResponse(true, obj, classT);
                        } catch (ClassNotFoundException e) {
                            e.printStackTrace();
                        } catch (JSONException e) {
                            e.printStackTrace();
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
                });
            }
        });
    }

    public static void addComment(final String className, final int id, final String comment, final OnJSONResponseCallback callback) {
        RequestParams params = new RequestParams();

        params.put("content", comment);

        currentUser.getSecureKey(params, new User.OnJSONResponseCallback() {

            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException {
                ActiveRecord.secureCase(currentUser, params, response.getString("key"));
                AsyncHttpClient client = new AsyncHttpClient();
                char lastChar = className.charAt(className.length() - 1);

                client.post("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "/addcomment/" : "s/addcomment/") + Integer.toString(id), params, new JsonHttpResponseHandler() {
                    @Override
                    public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                        Log.v("JSON ADDCOMMENT", response.toString());
                        /*
                            final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);
                            JSONObject obj = response.getJSONObject("content");

                            callback.onJSONResponse(true, obj, classT);
                         */
                    }

                    @Override
                    public void onFailure(int statusCode, Header[] headers, Throwable e, JSONObject response) {
                        Log.v("FAIL", response.toString());
                    }
                });
            }
        });

    }

    public static void getComments(String className, int id, int offset, int limit, final OnJSONResponseCallback callback) throws ClassNotFoundException {
        final Class<?> classT = Class.forName("com.soonzik.testsupermodel." + className);

        RequestParams params = new RequestParams();
        AsyncHttpClient client = new AsyncHttpClient();

        if (offset > 0) {
            params.put("offset", Integer.toString(offset));
        }
        if (limit > 0) {
            params.put("limit", Integer.toString(limit));
        }

        char lastChar = className.charAt(className.length() - 1);
        client.get("http://10.0.3.2:3000/api/" + className.toLowerCase() + (lastChar == 's' ? "" : "s/") + Integer.toString(id) + "/comments", params, new JsonHttpResponseHandler() {
            @Override
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                try {
                    JSONArray data = response.getJSONArray("content");
                    Log.v("JSON GETCOMMENTS", data.toString());

                    callback.onJSONResponse(true, data, classT);
                } catch (JSONException | InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
                    e.printStackTrace();
                }
            }
            @Override
            public void onFailure(int statusCode, Header[]headers, Throwable e, JSONObject response) {
                Log.v("FAIL", response.toString());
            }

        });
    }

    public static void login(String email, String password, final OnJSONResponseCallback callback) {
        AsyncHttpClient client = new AsyncHttpClient();
        RequestParams params = new RequestParams();

        /* Pour realiser le hash du passeword avec bcypt et verifier si ca colle

        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());

        if (BCrypt.checkpw(password, hashed))
            Log.v("HASH", "It matches");
        else
            Log.v("HASH", "It does not match");

        */

        params.put("email", email);
        params.put("password", password/*hashed*/);

        client.post("http://10.0.3.2:3000/api/login", params, new JsonHttpResponseHandler() {
            public void onSuccess(int statusCode, Header[] headers, JSONObject response) {
                try {
                    final Class<?> classT = Class.forName("com.soonzik.testsupermodel.User");
                    JSONObject obj = response.getJSONObject("content");
                    Log.v("LOGIN JSON", obj.toString());

                    callback.onJSONResponse(true, obj, classT);
                } catch (JSONException e) {
                    e.printStackTrace();
                } catch (ClassNotFoundException e) {
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

    protected static void secureCase(User user, RequestParams params, String secureKey) throws NoSuchAlgorithmException, UnsupportedEncodingException {

        Log.v("SECUREHEY", secureKey);

        String toHash = user.getSalt() + secureKey;

        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(toHash.getBytes("UTF-8"));
        StringBuffer hexString = new StringBuffer();

        for (int i = 0; i < hash.length; i++) {
            String hex = Integer.toHexString(0xff & hash[i]);
            if(hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }

        params.put("user_id", user.getId());
        params.put("secureKey", hexString);
    }

    protected void createInstance( Object instance, JSONObject obj, Class<?> classT) {
        Iterator itr = obj.keys();
        while (itr.hasNext()) {
            String attr = (String) itr.next();
            try {
                Log.v("CREATE INSTANCE", classT.toString());

                Field field = classT.getDeclaredField(attr);
                field.setAccessible(true);

                field.set(instance, Utils.dispatchAttribute(field.getType(), obj, attr));

            } catch (NoSuchFieldException | NoSuchMethodException | InvocationTargetException | JSONException | IllegalAccessException | InstantiationException | ClassNotFoundException | ParseException e) {
                e.printStackTrace();
            }
        }
    }

    public static void setCurrentUser(User _currentUser) {
        currentUser = _currentUser;
    }

}