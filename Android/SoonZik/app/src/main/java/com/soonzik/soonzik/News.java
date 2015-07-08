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
    private Date date = null;
    private String news_type = "";
    private User user = null;
    private ArrayList<Newstext> newstexts = null;
    private ArrayList<Attachment> attachments = null;
    private ArrayList<Tag> tags = null;

    public News() {}

    public News(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        String str = "id = " + Integer.toString(id)
                    + " : author = { " + (user != null ? user.toString() : "") + " }"
                    + " : date = " + (date != null ? date.toString() : "")
                    + " : newstexts = [";
        if (newstexts != null) {
            for (Newstext newstext : newstexts) {
                str += "{ " + newstext.toString() + " } ";
            }
        }
        str += " ]";
        str += " : attachments = [ ";
        if (attachments != null) {
            for (Attachment attachment : attachments) {
                str += "{ " + attachment.toString() + " } ";
            }
        }
        str += " ]";
        str += " : tag = [ ";
        if (tags != null) {
            for (Tag tag : tags) {
                str += "{ " + tag.toString() + " } ";
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

    public Date getDate() {
        return date;
    }

    public String getNews_type() {
        return news_type;
    }

    public User getUser() {
        return user;
    }

    public ArrayList<Newstext> getNewstexts() {
        return newstexts;
    }

    public ArrayList<Attachment> getAttachments() {
        return attachments;
    }

    public ArrayList<Tag> getTags() {
        return tags;
    }
}
