package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by kevin_000 on 27/05/2015.
 */
public class Search extends ActiveRecord {

    private ArrayList<User> artist = null;
    private ArrayList<User> user = null;
    private ArrayList<Music> music = null;
    private ArrayList<Album> album = null;
    private ArrayList<Pack> pack = null;

    public Search() {}

    public Search(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "";

        str += "artist = [ ";
        if (artist != null) {
            for (User art : artist) {
                str += "{ " + art.toString() + " } ";
            }
        }
        str += " ]";
        str += " : user = [ ";
        if (user != null) {
            for (User usr : user) {
                str += "{ " + usr.toString() + " } ";
            }
        }
        str += " ]";
        str += " : music = [ ";
        if (music != null) {
            for (Music mus : music) {
                str += "{ " + mus.toString() + " } ";
            }
        }
        str += " ]";
        str += " : album = [ ";
        if (album != null) {
            for (Album alb : album) {
                str += "{ " + alb.toString() + " } ";
            }
        }
        str += " ]";
        str += " : pack = [ ";
        if (pack != null) {
            for (Pack pck : pack) {
                str += "{ " + pck.toString() + " } ";
            }
        }
        str += " ]";
        return str;
    }

    public ArrayList<User> getArtist() {
        return artist;
    }

    public ArrayList<User> getUser() {
        return user;
    }

    public ArrayList<Music> getMusic() {
        return music;
    }

    public ArrayList<Album> getAlbum() {
        return album;
    }

    public ArrayList<Pack> getPack() {
        return pack;
    }

}
