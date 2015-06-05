package com.soonzik.testsupermodel;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Pack extends ActiveRecord {
    private int id = -1;
    private String title = "";
    private Genre genre = null;
    private ArrayList<Album> albums = null;


    public Pack() {}

    public Pack(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                + " : title = " + title
                + " : Genre = {" + (genre != null ? genre.toString() : "") + " }";
        str += " : Album = [ ";
        if (albums != null) {
            for (Album album: albums) {
                str += "{ " + album.toString() + " } ";
            }
        }
        str += " ]";
        return (str);
    }

    public String getTitle() {
        return title;
    }

    public int getId() {
        return id;
    }
}
