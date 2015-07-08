package com.soonzik.soonzik;

import org.json.JSONObject;

/**
 * Created by kevin_000 on 21/03/2015.
 */
public class Attachment extends ActiveRecord {
    private int id = -1;
    private String url = "";
    private String file_size = "";
    private String content_type = "";

    public Attachment() {}

    public Attachment(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    @Override
    public String toString() {
        return (
                "id = " + Integer.toString(id)
                + " : url = " + url
                + " : file_size = " + file_size
                + " : content_type = " + content_type
                );
    }
}
