package com.soonzik.soonzik;

import org.json.JSONObject;

/**
 * Created by Kevin on 2015-11-08.
 */

public class Like extends ActiveRecord {
    public Like() {}

    public Like(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }
}
