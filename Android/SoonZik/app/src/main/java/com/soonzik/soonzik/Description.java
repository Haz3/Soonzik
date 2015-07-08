package com.soonzik.soonzik;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 16/06/2015.
 */
public class Description extends ActiveRecord {

    private int id = -1;
    private String description = "";
    private String language = "";

    public Description() {}

    public Description(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                + " : description = " + description
                + " : language = " + language;

        return (str);
    }

    public String getLanguage() {
        return language;
    }

    public String getDescription() {
        return description;
    }
}
