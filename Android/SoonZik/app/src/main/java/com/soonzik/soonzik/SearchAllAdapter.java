package com.soonzik.soonzik;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
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
                Pack pc = (Pack) values.get(position);

                ImageView imageViewPack = (ImageView) rowPack.findViewById(R.id.packpicture);
                imageViewPack.setImageResource(R.drawable.ic_profile);

                ArrayList<Album> alb = pc.getAlbums();

                String arts = "";
                ArrayList<String> artistes = new ArrayList<String>();

                int nbalb = 0;
                if (alb != null) {
                    nbalb = alb.size();
                    String tmp = "";
                    for (Album album : alb) {
                        tmp = album.getUser().getUsername();
                        if (!artistes.contains(tmp))
                            artistes.add(tmp);
                    }
                    int i = 1;
                    for (String name : artistes) {
                        arts += name;
                        if (i < artistes.size())
                            arts += " / ";
                        i++;
                    }
                }

                TextView textViewArtists = (TextView) rowPack.findViewById(R.id.albumtitle);
                textViewArtists.setText(arts);

                TextView textViewNbAlbums = (TextView) rowPack.findViewById(R.id.nbalbums);
                textViewNbAlbums.setText(Integer.toString(nbalb));

                TextView textViewTitlePack = (TextView) rowPack.findViewById(R.id.musictitle);
                textViewTitlePack.setText(pc.getTitle());
                return rowPack;
            case "Album" :
                View rowAlbum = inflater.inflate(R.layout.row_albums, parent, false);
                TextView textAlbumView = (TextView) rowAlbum.findViewById(R.id.label);
                Album ab = (Album) values.get(position);
                textAlbumView.setText(ab.getTitle());
                return rowAlbum;
            case "Music" :
                View rowMusic = inflater.inflate(R.layout.row_musics, parent, false);
                Music ms = (Music) values.get(position);

                ImageView imageViewMusic = (ImageView) rowMusic.findViewById(R.id.albumpicture);
                imageViewMusic.setImageResource(R.drawable.ic_profile);

                /*TextView textViewArtist = (TextView) rowMusic.findViewById(R.id.nameartist);
                textViewArtist.setText(ms.getUser().getUsername());*/

                int duration = ms.getDuration();

                int min = duration / 60;
                int sec = duration - (min * 60);
                String time = "";

                time += (min < 10 ? "0" : "") + Integer.toString(min) + ":";
                time += (sec < 10 ? "0" : "") + Integer.toString(sec);

                TextView textViewDuration = (TextView) rowMusic.findViewById(R.id.durationtitle);
                textViewDuration.setText(time);

                TextView textViewTitleMusic = (TextView) rowMusic.findViewById(R.id.title);
                textViewTitleMusic.setText(ms.getTitle());
                return rowMusic;
            default:
                View rowView = inflater.inflate(R.layout.row_searchs, parent, false);
                TextView textView = (TextView) rowView.findViewById(R.id.label);
                textView.setText(Integer.toString(position));
                return rowView;
        }
    }
}
