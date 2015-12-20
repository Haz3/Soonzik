package com.soonzik.soonzik;

import org.json.JSONObject;

/**
 * Created by Kevin on 2015-11-29.
 */
public class Feedback extends ActiveRecord {
    public Feedback() {}

    public Feedback(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }
}
