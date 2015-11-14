package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class Influence extends ActiveRecord {
    private int id = -1;
    private String name = "";
    private ArrayList<Genre> genres = null;

    public Influence() {}

    public Influence(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "";
        str += "id = " + Integer.toString(id)
                + " : name = " + name;
        str += " : genres = [ ";
        if (genres != null) {
            for (Genre genre : genres) {
                str += "{ " + genre.toString() + " } ";
            }
        }

        return (str);
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public ArrayList<Genre> getGenres() {
        return genres;
    }
}
