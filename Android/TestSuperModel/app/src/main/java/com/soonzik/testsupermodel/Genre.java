package com.soonzik.testsupermodel;

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
}
