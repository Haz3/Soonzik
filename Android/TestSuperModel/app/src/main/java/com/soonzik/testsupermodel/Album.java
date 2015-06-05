package com.soonzik.testsupermodel;

import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Album extends ActiveRecord {
    private int id = -1;
    private User owner = null;
    private String title = "";
    private Genre genre = null;
    private double price = -1;
    private String image = "";
    private int yearProd = 0;
    private ArrayList<Commentary> commentary = null;
    private double note = 0.0;

    private String file = "";

    public Album() {}

    public Album(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                + " : User = {" + (owner != null ? owner.toString() : "") + " }"
                + " : title = " + title
                + " : Genre { " + (genre != null ? genre.toString() : "") + " }"
                + " : price = " + Double.toString(price)
                + " : image = " + image
                + " : note = " + Double.toString(note)
                + " : yearProd = " + Integer.toString(yearProd);
        str += " : Commentary = [ ";
        if (commentary != null) {
            for (Commentary comment : commentary) {
                str += "{ " + comment.toString() + " } ";
            }
        }
        str += " ]";
        return (str);
    }

    public int getId() {
        return id;
    }

    public User getOwner() {
        return owner;
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

    public ArrayList<Commentary> getCommentary() {
        return commentary;
    }

    public double getNote() {
        return note;
    }

    public String getFile() {
        return file;
    }
}
