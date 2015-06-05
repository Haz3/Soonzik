package com.soonzik.testsupermodel;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Tweet extends ActiveRecord {
    private int id = -1;
    private String msg = "";
    private User writer = null;

    public Tweet() {}

    public Tweet(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : msg = " + msg
                + " : writer = { " + (writer != null ? writer.toString() : "") + "  }"
                );
    }
}
