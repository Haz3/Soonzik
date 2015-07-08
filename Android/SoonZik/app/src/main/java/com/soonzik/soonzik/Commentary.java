package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Commentary extends ActiveRecord {
    private int id = -1;
    private String text = "";
    private Date date = null;

    public Commentary() {}

    public Commentary(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : text = " + text
                + " : date = " + (date != null ? date.toString() : "")
                );
    }
}
