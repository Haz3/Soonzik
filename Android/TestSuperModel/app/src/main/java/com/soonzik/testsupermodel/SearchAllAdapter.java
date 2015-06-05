package com.soonzik.testsupermodel;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

/**
 * Created by kevin_000 on 28/05/2015.
 */
public class SearchAllAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    public SearchAllAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_searchs, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        String className = values.get(position).getClass().getSimpleName();

        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        switch (className) {
            case "User" :
                View rowUser = inflater.inflate(R.layout.row_users, parent, false);
                TextView textUserView = (TextView) rowUser.findViewById(R.id.label);
                User us = (User) values.get(position);
                textUserView.setText(us.getUsername());
                return rowUser;
            case "Pack" :
                View rowPack = inflater.inflate(R.layout.row_packs, parent, false);
                TextView textPackView = (TextView) rowPack.findViewById(R.id.label);
                Pack pc = (Pack) values.get(position);
                textPackView.setText(pc.getTitle());
                return rowPack;
            case "Album" :
                View rowAlbum = inflater.inflate(R.layout.row_albums, parent, false);
                TextView textAlbumView = (TextView) rowAlbum.findViewById(R.id.label);
                Album ab = (Album) values.get(position);
                textAlbumView.setText(ab.getTitle());
                return rowAlbum;
            case "Music" :
                View rowMusic = inflater.inflate(R.layout.row_musics, parent, false);
                TextView textMusicView = (TextView) rowMusic.findViewById(R.id.label);
                Music ms = (Music) values.get(position);
                textMusicView.setText(ms.getTitle());
                return rowMusic;
            default:
                View rowView = inflater.inflate(R.layout.row_searchs, parent, false);
                TextView textView = (TextView) rowView.findViewById(R.id.label);
                textView.setText(Integer.toString(position));
                return rowView;
        }
    }
}
