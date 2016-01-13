package com.soonzik.soonzik;

import android.widget.ListView;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Kevin on 2016-01-07.
 */
public class Ambiance extends ActiveRecord {

    private int id;
    private String name;
    private ArrayList<Music> musics;

    public Ambiance() {}

    public Ambiance(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public String toString() {
        String str = "id = " + Integer.toString(id);
        str += " : name = " + name;
        str += " : musics = [ ";
        if (musics != null) {
            for (Music m : musics) {
                str += "{ " + m.toString() + " } ";
            }
        }
        str += " ]";
        return (str);
    }

    public String getName() {
        return name;
    }

    public int getId() {
        return id;
    }

    public ArrayList<Music> getMusics() {
        return musics;
    }
}
