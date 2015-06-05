package com.soonzik.testsupermodel;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class Influence extends ActiveRecord {
    private int id = -1;
    private String name = "";

    public Influence() {}

    public Influence(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                        + " : name = " + name
        );
    }

}
