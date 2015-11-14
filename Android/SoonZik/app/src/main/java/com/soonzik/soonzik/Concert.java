package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Concert extends ActiveRecord {
    private int id = -1;
    private User user = null;
    private Address address = null;
    private String url = "";
    private Date planification = null;
    private int likes = 0;
    private boolean hasLiked = false;

    public Concert() {}

    public Concert(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                        + " : User = { " + (user != null ? user.toString() : "") + " }"
                        + " : Address = { " + (address != null ? address.toString() : "") + " }"
                        + " : url = " + url
                        + " : Date = " + (planification != null ? planification.toString() : "")
                        + " : likes = " + Integer.toString(likes)
                        + " : hasLiked = " + Boolean.toString(hasLiked));
    }

    public int getId() {
        return id;
    }

    public User getUser() {
        return user;
    }

    public Address getAddress() {
        return address;
    }

    public String getUrl() {
        return url;
    }

    public Date getPlanification() {
        return planification;
    }

    public int getLikes() {
        return likes;
    }

    public boolean isHasLiked() {
        return hasLiked;
    }

    public void setLikes(int likes) {
        this.likes = likes;
    }

    public void setHasLiked(boolean hasLiked) {
        this.hasLiked = hasLiked;
    }
}
