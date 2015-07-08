package com.soonzik.soonzik;

import android.util.Log;
import android.util.Pair;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.math.BigInteger;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Map;

/**
 * Created by kevin_000 on 13/03/2015.
 */
public class Utils {

    public static Object dispatchAttribute(Class<?> classType, JSONObject json, String key) throws JSONException, NoSuchMethodException, IllegalAccessException, InvocationTargetException, InstantiationException, ClassNotFoundException, ParseException {
        switch (classType.getSimpleName()) {
            case "int":
                return (json.getInt(key));
            case "double":
                return (json.getDouble(key));
            case "String":
                return (json.getString(key));
            case "boolean":
                return (json.getBoolean(key));
            case "Date" :
                return (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(json.getString(key)));
            case "ArrayList":
                JSONArray arrayObj = json.getJSONArray(key);
                String newKey = Utils.getObjectName(key);

                Log.v("KEY", "key = " + key + " : newKey = " + newKey);

                Class<?> newType = Class.forName("com.soonzik.soonzik." + newKey);
                ArrayList<Object> list = new ArrayList<Object>();
                for (int i = 0; i < arrayObj.length(); i++) {
                    JSONObject obj = new JSONObject();
                    obj.put(newKey, arrayObj.getJSONObject(i));
                    list.add(dispatchAttribute(newType, obj, newKey));
                }
                return (list);
            default:
                Constructor constructor = classType.getDeclaredConstructor(JSONObject.class);
                constructor.setAccessible(true);
                return (constructor.newInstance(json.getJSONObject(key)));
        }
    }

    public static String getObjectName(String key) {
        switch (key) {
            case "follows":
                return ("User");
            case "friends":
                return ("User");
            case "users":
                return ("User");
            case "votes":
                return ("Vote");
            case "genres":
                return ("Genre");
            case "tags":
                return ("Tag");
            case "newstexts" :
                return ("Newstext");
            case "artist" :
                return ("User");
            case "attachments" :
                return ("Attachment");
            case "music" :
                return ("Music");
            case "musics" :
                return ("Music");
            case "topFive" :
                return ("Music");
            case "user" :
                return ("User");
            case "pack":
                return ("Pack");
            case "album":
                return ("Album");
            case "albums":
                return ("Album");
            case "influences":
                return ("Influence");
            case "descriptions":
                return ("Description");
            default:
                return (null);
        }
    }

    public static ArrayList<Pair<String, String>> formatURL(Map<String, Object> params) {

        ArrayList<Pair<String, String>> paramList = new ArrayList<>();

        for (Map.Entry<String, Object> entry : params.entrySet()) {
            String key = entry.getKey();
            switch (key) {
                case "attribute":
                    Map<String, String> attrValue = (Map<String, String>) entry.getValue();
                    for (Map.Entry<String, String> ent : attrValue.entrySet()) {
                        paramList.add(new Pair<>(key + "[" + ent.getKey() + "]", ent.getValue()));
                    }
                    break;
                case "order_by_asc":
                    ArrayList<String> orderAscValue =  (ArrayList<String>) entry.getValue();
                    for (int i = 0; i < orderAscValue.size(); i++) {
                        paramList.add(new Pair<>(key + "[]", orderAscValue.get(i)));
                    }
                    break;
                case "order_by_desc":
                    ArrayList<String> orderDscValue =  (ArrayList<String>) entry.getValue();
                    for (int i = 0; i < orderDscValue.size(); i++) {
                        paramList.add(new Pair<>(key + "[]", orderDscValue.get(i)));
                    }
                    break;
                case "group_by":
                    ArrayList<String> groupValue =  (ArrayList<String>) entry.getValue();
                    for (int i = 0; i < groupValue.size(); i++) {
                        paramList.add(new Pair<>(key + "[]", groupValue.get(i)));
                    }
                    break;
                case "limit":
                    String limitValue = entry.getValue().toString();
                    paramList.add(new Pair<>(key, limitValue));
                    break;
                case "offset":
                    String offsetValue = entry.getValue().toString();
                    paramList.add(new Pair<>(key, offsetValue));
                    break;
                default:
                    break;
            }
        }
        return (paramList);
    }

    public static String bin2hex(byte[] data) {
        return String.format("%0" + (data.length * 2) + 'x', new BigInteger(1, data));
    }
}
