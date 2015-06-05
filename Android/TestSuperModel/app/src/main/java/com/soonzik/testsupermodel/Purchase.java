package com.soonzik.testsupermodel;

import org.json.JSONObject;

import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Purchase extends ActiveRecord {
    private int id = -1;
    private Music music = null;
    private Album album = null;
    private Pack pack = null;
    private Date date = null;

    public Purchase() {}

    public Purchase(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                 + " : music = { " + (music != null ? music.toString() : "") + " }"
                 + " : album = { " + (album != null ? album.toString() : "") + " }"
                 + " : pack = { " + (pack != null ? pack.toString() : "") + " }"
                 + " : date = " + (date != null ? date.toString() : "")
        );
    }

}
