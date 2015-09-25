package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by Kevin on 2015-09-01.
 */
public class MyContent extends ActiveRecord {

    private ArrayList<Music> musics = null;
    private ArrayList<Album> albums = null;
    private ArrayList<Pack> packs = null;

    public MyContent() {}

    public MyContent(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public String toString() {
        String str = "Musics = [ ";
        if (musics != null) {
            for (Music music : musics) {
                str += "{ " + music.toString() +  " } ";
            }
        }
        str += " ]";

        str += " : Albums = [ ";
        if (albums != null) {
            for (Album album : albums) {
                str += "{ " + album.toString() +  " } ";
            }
        }
        str += " ]";
        str += " : Packs = [ ";
        if (packs != null) {
            for (Pack pack : packs) {
                str += "{ " + pack.toString() +  " } ";
            }
        }
        str += " ]";

        return str;
    }

    public ArrayList<Music> getMusics() {
        return musics;
    }

    public ArrayList<Album> getAlbums() {
        return albums;
    }

    public ArrayList<Pack> getPacks() {
        return packs;
    }
}
