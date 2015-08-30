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

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Gift extends ActiveRecord {
    private int id = -1;
    private User from = null;
    private User to = null;
    private String typeObj = "";
    private Object object = null;

    public Gift() {}

    public Gift(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }



    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : from = { " + (from != null ? from.toString() : "") + " }"
                + " : to = { " + (to != null ? to.toString() : "") + " }"
                + " : typeObj = " + typeObj
                + " : object = { " + (object != null ? object.toString() : "") + " }"
                );
    }
}
