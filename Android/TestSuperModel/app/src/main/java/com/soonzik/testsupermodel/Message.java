package com.soonzik.testsupermodel;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Message extends ActiveRecord {
    private int id = -1;
    private String msg = null;
    private User user_send = null;
    private User user_dest = null;

    public Message() {}

    public Message(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : msg = " + msg
                + " : User_send = { " + (user_send != null ? user_send.toString() : "") + " }"
                + " : User_dest = { " + (user_dest != null ? user_dest.toString() : "") + " }"
                );
    }

}
