package com.soonzik.soonzik;

import org.json.JSONObject;

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
