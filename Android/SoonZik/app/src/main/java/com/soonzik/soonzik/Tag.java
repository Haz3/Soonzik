package com.soonzik.soonzik;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 05/05/2015.
 */
public class Tag extends ActiveRecord {

    int id;

    public Tag() {};

    public Tag(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public String toString() {
        return (
                "id = " + Integer.toString(id)
                );
    }

}
