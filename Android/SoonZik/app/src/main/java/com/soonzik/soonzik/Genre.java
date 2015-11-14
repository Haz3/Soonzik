package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Genre extends ActiveRecord {
    private int id = -1;
    private String style_name = "";
    private String color_name = "";
    private String color_hexa = "";
    private ArrayList<Influence> influences = null;
    private ArrayList<Music> musics = null;

    public Genre() {}

    public Genre(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                + " : name = " + style_name
                + " : color_name = " + color_name
                + " : color_hexa = " + color_hexa;

        str += " : influences = [ ";
        if (influences != null) {
            for (Influence influence : influences) {
                str += "{ " + influences.toString() + " } ";
            }
        }
        str += "]";
        return (str);
    }

    public String getName() {
        return style_name;
    }

    public int getId() {
        return id;
    }

    public String getStyle_name() {
        return style_name;
    }

    public String getColor_name() {
        return color_name;
    }

    public String getColor_hexa() {
        return color_hexa;
    }

    public ArrayList<Influence> getInfluences() {
        return influences;
    }

    public ArrayList<Music> getMusics() {
        return musics;
    }
}
