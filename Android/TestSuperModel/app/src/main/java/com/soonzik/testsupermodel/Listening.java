package com.soonzik.testsupermodel;

import org.json.JSONObject;

import java.util.Date;
import java.util.List;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Listening extends ActiveRecord {
    private Music music = null;
    private Date when = null;
    private double latitude = 0;
    private double longitude = 0;

    public Listening() {}

    public Listening(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "Music = { " + (music != null ? music.toString() : "") + " }"
                + " : when = " + (when != null ? when.toString() : "")
                + " : latitude = " + Double.toString(latitude)
                + " : longitude = " + Double.toString(longitude)
                );
    }

}
