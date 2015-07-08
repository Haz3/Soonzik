package com.soonzik.soonzik;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 29/06/2015.
 */
public class Vote extends ActiveRecord {
    private int id = -1;
    private int user_id = -1;
    private int artist_id = -1;

    public Vote() {}

    public Vote(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public String toString() {
        String str = "";

        str += "id = " + Integer.toString(id)
                + " : user_id = " + Integer.toString(user_id)
                + " : artist_id = " + Integer.toString(artist_id);

        return str;
    }

    public int getId() {
        return id;
    }

    public int getUser_id() {
        return user_id;
    }

    public int getArtist_id() {
        return artist_id;
    }
}
