package com.soonzik.testsupermodel;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 05/05/2015.
 */
public class Newstext extends ActiveRecord {

    int id = -1;
    String content = "";
    String title = "";
    String language = "";

    public Newstext() {};

    public Newstext(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public String toString() {
        return (
                "id = " + Integer.toString(id) +
                        " : content = " + content +
                        " : title = " + title +
                        " : language = " + language
                );
    }

    public String getLanguage() {
        return language;
    }

    public String getContent() {
        return content;
    }

    public String getTitle() {
        return title;
    }
}
