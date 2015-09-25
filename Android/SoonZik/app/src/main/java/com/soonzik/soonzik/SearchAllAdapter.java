package com.soonzik.soonzik;

import android.app.Activity;
import android.app.DialogFragment;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONException;

import java.lang.reflect.InvocationTargetException;
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
    public View getView(final int position, View convertView, ViewGroup parent) {
        String className = values.get(position).getClass().getSimpleName();

        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        switch (className) {
            case "User" :
                View rowUser = inflater.inflate(R.layout.row_users, parent, false);
                final User us = (User) values.get(position);

                TextView username = (TextView) rowUser.findViewById(R.id.username);
                username.setText(us.getUsername());

                TextView userLanguage = (TextView) rowUser.findViewById(R.id.userlanguage);
                userLanguage.setText(us.getLanguage());

                final TextView nbFollowers = (TextView) rowUser.findViewById(R.id.nbfollowers);
                User.getFollowers(us.getId(), new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException, JSONException {
                        JSONArray data = (JSONArray) response;

                        List<Object> followers = ActiveRecord.jsonArrayData(data, classT);
                        nbFollowers.setText(Integer.toString(followers.size()));
                    }
                });

                rowUser.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Bundle bundle = new Bundle();
                        bundle.putInt("artist_id", us.getId());
                        Fragment frg = Fragment.instantiate(context, "com.soonzik.soonzik.ArtistFragment");
                        frg.setArguments(bundle);

                        FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                        tx.replace(R.id.main, frg);
                        tx.addToBackStack(null);
                        tx.commit();
                    }
                });
                return rowUser;
            case "Pack" :
                View rowPack = inflater.inflate(R.layout.row_packs, parent, false);

                final Pack pc = (Pack) values.get(position);

                rowPack.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Bundle bundle = new Bundle();
                        bundle.putInt("pack_id", pc.getId());
                        Fragment frg = Fragment.instantiate(context, "com.soonzik.soonzik.PackFragment");
                        frg.setArguments(bundle);

                        FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                        tx.replace(R.id.main, frg);
                        tx.addToBackStack(null);
                        tx.commit();
                    }
                });

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

                TextView textViewTitlePack = (TextView) rowPack.findViewById(R.id.artistname);
                textViewTitlePack.setText(pc.getTitle());
                return rowPack;
            case "Album" :
                View rowAlbum = inflater.inflate(R.layout.row_albums, parent, false);
                final Album al = (Album) values.get(position);

                rowAlbum.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        Bundle bundle = new Bundle();
                        bundle.putInt("album_id", al.getId());
                        Fragment frg = Fragment.instantiate(context, "com.soonzik.soonzik.AlbumFragment");
                        frg.setArguments(bundle);

                        FragmentTransaction tx = ((FragmentActivity)context).getSupportFragmentManager().beginTransaction();
                        tx.replace(R.id.main, frg);
                        tx.addToBackStack(null);
                        tx.commit();
                    }
                });


                TextView title = (TextView) rowAlbum.findViewById(R.id.albumtitle);
                title.setText(al.getTitle());

                TextView artistname = (TextView) rowAlbum.findViewById(R.id.artistname);
                artistname.setText(al.getUser().getUsername());

                TextView nbTitle = (TextView) rowAlbum.findViewById(R.id.nbtitle);
                nbTitle.setText(Integer.toString(al.getMusics().size()));
                return rowAlbum;
            case "Music" :
                View rowMusic = inflater.inflate(R.layout.row_musics, parent, false);
                final Music ms = (Music) values.get(position);

                ImageView imageViewMusic = (ImageView) rowMusic.findViewById(R.id.albumpicture);
                imageViewMusic.setImageResource(R.drawable.ic_profile);

                TextView textViewArtist = (TextView) rowMusic.findViewById(R.id.artistname);
                textViewArtist.setText(ms.getUser().getUsername());

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

                TextView musication = (TextView) rowMusic.findViewById(R.id.musicaction);
                musication.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        DialogFragment newFragment = new MusicActionDialogFragment();
                        Bundle bundle = new Bundle();
                        bundle.putInt("music_id", ms.getId());

                        newFragment.setArguments(bundle);
                        newFragment.show(((FragmentActivity) context).getFragmentManager(), "com.soonzik.soonzik.MusicActionDialogFragment");
                    }
                });
                return rowMusic;
            default:
                View rowView = inflater.inflate(R.layout.row_searchs, parent, false);
                TextView textView = (TextView) rowView.findViewById(R.id.label);
                textView.setText(Integer.toString(position));
                return rowView;
        }
    }
}
