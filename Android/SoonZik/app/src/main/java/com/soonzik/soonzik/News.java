package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class News extends ActiveRecord {
    private int id = -1;
    private String title = "";
    private Date created_at = null;
    private User user = null;
    private String content = "";
    private ArrayList<Attachment> attachments = null;
    private int likes = 0;
    private boolean hasLiked = false;

    public News() {}

    public News(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                    + " : user = { " + (user != null ? user.toString() : "") + " }"
                    + " : created_at = " + (created_at != null ? created_at.toString() : "")
                    + " : title = " + title
                    + " : content = " + content
                    + " : likes = " + Integer.toString(likes)
                    + " : hasLiked = " + Boolean.toString(hasLiked);
        str += " : attachments = [ ";
        if (attachments != null) {
            for (Attachment attachment : attachments) {
                str += "{ " + attachment.toString() + " } ";
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

    public Date getCreated_at() {
        return created_at;
    }

    public User getUser() {
        return user;
    }

    public ArrayList<Attachment> getAttachments() {
        return attachments;
    }

    public String getContent() {
        return content;
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
