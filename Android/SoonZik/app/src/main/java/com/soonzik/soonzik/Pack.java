package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Pack extends ActiveRecord {
    private int id = -1;
    private String title = "";
    private ArrayList<Album> albums = null;
    private User user = null;
    private ArrayList<Description> descriptions = null;
    private double minimal_price = 0d;
    private double averagePrice = 0d;
    private Date begin_date = null;
    private Date end_date = null;

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
        str += " : minimal_price = " + Double.toString(minimal_price);
        str += " : averagePrice = " + Double.toString(averagePrice);
        str += " : begin_date = " + (begin_date != null ? begin_date.toString() : "");
        str += " : end_date = " + (end_date != null ? end_date.toString() : "");
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

    public double getMinimal_price() {
        return minimal_price;
    }

    public double getAveragePrice() {
        return averagePrice;
    }

    public Date getEnd_date() {
        return end_date;
    }

    public Date getBegin_date() {
        return begin_date;
    }
}
