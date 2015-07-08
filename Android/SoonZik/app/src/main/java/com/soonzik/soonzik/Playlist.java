package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Playlist extends ActiveRecord {
    private int id = -1;
    private String name = "";
    private ArrayList<Music> musics = null;
    private User user = null;

    public Playlist() {}

    public Playlist(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                    + " : title = " + name;
        str += " : Musics = [";
        if (musics != null) {
            for (Music music : musics) {
                str += "{ " + music.toString() + " } ";
            }
        }
        str += " ]" + " : user = " + user.toString();
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

    public User getUser() {
        return user;
    }
}
