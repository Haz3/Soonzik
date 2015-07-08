package com.soonzik.soonzik;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Notification extends ActiveRecord {
    private int id = -1;
    private String link = "";
    private String description = "";

    public Notification() {}

    public Notification(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : link = " + link
                + " : description = " + description
                );
    }

}
