package com.soonzik.testsupermodel;

import org.json.JSONObject;

import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Concert extends ActiveRecord {
    private int id = -1;
    private Address address = null;
    private Date date = null;

    public Concert() {}

    public Concert(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : Address = { " + (address != null ? address.toString() : "") + " }"
                + " : Date = " + (date != null ? date.toString() : "")
                );
    }
}
