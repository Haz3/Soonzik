package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Commentary extends ActiveRecord {
    private int id = -1;
    private User user = null;
    private Date created_at = null;
    private String content = "";

    public Commentary() {}

    public Commentary(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                        + " : user = { " + (user != null ? user.toString() : "") + " }"
                + " : created_at = " + (created_at != null ? created_at.toString() : "")
                        + " : content = " + content
                );
    }

    public int getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public String getContent() {
        return content;
    }
}
