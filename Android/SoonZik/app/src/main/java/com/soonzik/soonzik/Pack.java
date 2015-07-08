package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Pack extends ActiveRecord {
    private int id = -1;
    private String title = "";
    private ArrayList<Album> albums = null;
    private User user = null;
    private ArrayList<Description> descriptions = null;

    public Pack() {}

    public Pack(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                + " : title = " + title;
        str += " : Album = [ ";
        if (albums != null) {
            for (Album album: albums) {
                str += "{ " + album.toString() + " } ";
            }
        }
        str += " ]";
        str += " : User = [ " + (user != null ? user.toString() : "") +  " ]";
        str += " : Description = [ ";
        if (descriptions != null) {
            for (Description description: descriptions) {
                str += "{ " + description.toString() + " } ";
            }
        }
        str += " ]";
        return (str);
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public ArrayList<Album> getAlbums() {
        return albums;
    }

    public ArrayList<Description> getDescriptions() {
        return descriptions;
    }

    public User getUser() {
        return user;
    }
}
