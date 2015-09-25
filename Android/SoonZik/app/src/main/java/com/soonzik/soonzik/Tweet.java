package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Tweet extends ActiveRecord {
    private int id = -1;
    private String msg = "";
    private User user = null;
    private Date created_at = null;

    public Tweet() {}

    public Tweet(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                        + " : msg = " + msg
                        + " : user = { " + (user != null ? user.toString() : "")  + "  }"
                        + " : date = { " + (created_at != null ? created_at.toString() : "") + "  }"
                );
    }

    public int getId() {
        return id;
    }

    public String getMsg() {
        return msg;
    }

    public User getUser() {
        return user;
    }

    public Date getCreated_at() {
        return created_at;
    }
}
