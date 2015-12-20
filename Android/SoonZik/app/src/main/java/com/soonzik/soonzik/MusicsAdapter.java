package com.soonzik.soonzik;

import android.app.Activity;
import android.app.DialogFragment;
import android.content.Context;
import android.content.DialogInterface;
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

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 28/05/2015.
 */
public class MusicsAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    public MusicsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_musics, objects);
        this.context = context;

        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_musics, parent, false);
        final Music ms = (Music) values.get(position);

        /*ImageView imageViewPicture = (ImageView) rowView.findViewById(R.id.albumpicture);
        imageViewPicture.setImageResource(R.drawable.ic_explorer);*/

        new Utils.ImageLoadTask("http://soonzikapi.herokuapp.com/assets/albums/" + ms.getAlbum().getImage(), (ImageView) rowView.findViewById(R.id.albumpicture)).execute();

        TextView textViewArtist = (TextView) rowView.findViewById(R.id.artistname);
        textViewArtist.setText(ms.getUser().getUsername());

        textViewArtist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putInt("artist_id", ms.getUser().getId());
                Fragment frg = Fragment.instantiate(context, redirectClass);
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        int duration = ms.getDuration();

        int min = duration / 60;
        int sec = duration - (min * 60);
        String time = "";

        time += (min < 10 ? "0" : "") + Integer.toString(min) + ":";
        time += (sec < 10 ? "0" : "") + Integer.toString(sec);

        TextView textViewDuration = (TextView) rowView.findViewById(R.id.durationtitle);
        textViewDuration.setText(time);

        TextView textViewTitle = (TextView) rowView.findViewById(R.id.title);
        textViewTitle.setText(ms.getTitle());

        TextView musication = (TextView) rowView.findViewById(R.id.musicaction);
        musication.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                DialogFragment newFragment = new MusicActionDialogFragment();
                Bundle bundle = new Bundle();
                bundle.putInt("music_id", ms.getId());

                newFragment.setArguments(bundle);
                newFragment.show(((Activity) context).getFragmentManager(), "com.soonzik.soonzik.MusicActionDialogFragment");
            }
        });

        rowView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Bundle bundle = new Bundle();

                ArrayList<Integer> ids = new ArrayList<Integer>();
                ids.add(ms.getId());
                bundle.putIntegerArrayList("music_ids", ids);
                bundle.putInt("index_music", 0);

                ArrayList<String> artist_names = new ArrayList<String>();
                artist_names.add(ms.getUser().getUsername());
                bundle.putStringArrayList("artist_names", artist_names);

                ArrayList<String> title_songs= new ArrayList<String>();
                title_songs.add(ms.getTitle());
                bundle.putStringArrayList("title_songs", title_songs);

                ArrayList<String> title_albums = new ArrayList<String>();
                title_albums.add(ms.getAlbum().getTitle());
                bundle.putStringArrayList("title_albums", title_albums);

                ArrayList<String> image_albums = new ArrayList<String>();
                image_albums.add("http://soonzikapi.herokuapp.com/assets/albums/" + ms.getAlbum().getImage());
                bundle.putStringArrayList("image_albums", image_albums);


                Fragment frg = Fragment.instantiate(context, "com.soonzik.soonzik.Player");
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        return rowView;
    }
}
