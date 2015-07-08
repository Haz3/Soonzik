package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Album extends ActiveRecord {
    private int id = -1;
    private User user = null;
    private String title = "";
    private Genre genre = null;
    private double price = -1;
    private String image = "";
    private int yearProd = 0;
    private double note = 0.0;
    private ArrayList<Music> musics = null;
    private ArrayList<Description> descriptions = null;

    private String file = "";

    public Album() {}

    public Album(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                + " : User = {" + (user != null ? user.toString() : "") + " }"
                + " : title = " + title
                + " : Genre { " + (genre != null ? genre.toString() : "") + " }"
                + " : price = " + Double.toString(price)
                + " : image = " + image
                + " : note = " + Double.toString(note)
                + " : yearProd = " + Integer.toString(yearProd);
        str += " : Music = [ ";
        if (musics != null) {
            for (Music music : musics) {
                str += "{ " + music.toString() + " } ";
            }
        }
        str += " ]";
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

    public User getUser() {
        return user;
    }

    public String getTitle() {
        return title;
    }

    public Genre getGenre() {
        return genre;
    }

    public double getPrice() {
        return price;
    }

    public String getImage() {
        return image;
    }

    public int getYearProd() {
        return yearProd;
    }

    public double getNote() {
        return note;
    }

    public String getFile() {
        return file;
    }

    public ArrayList<Music> getMusics() {
        return musics;
    }
}
