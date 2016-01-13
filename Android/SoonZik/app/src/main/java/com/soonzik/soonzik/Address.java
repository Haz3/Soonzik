package com.soonzik.soonzik;

import org.json.JSONObject;

import java.util.Date;

/**
 * Created by kevin_000 on 13/03/2015.
 */
public class Address extends ActiveRecord {

    private int id;
    private String numberStreet = "";
    private String complement = "";
    private String street = "";
    private String city = "";
    private String country = "";
    private String zipcode = "";
    private Date updated_at = null;
    private Date created_at = null;

    public Address() {}

    public Address(JSONObject json) {
        super.createInstance(this, json, this.getClass());
    }

    public String formatAddress() {
        return (numberStreet + ", " + street + " " + zipcode + " " + city + ", " + country);
    }

    public String toString() {
        return ("id = " + Integer.toString(id)
                + " : numberStreet = " + numberStreet
                + " : complement = " + complement
                + " : street = " + street
                + " : city = " + city
                + " : country = " + country
                + " : zipcode = " + zipcode
                + " : updated_at = " + (updated_at != null ? updated_at.toString() : "")
                + " : created_at = " + (created_at != null ? created_at.toString() : ""));
    }
}
