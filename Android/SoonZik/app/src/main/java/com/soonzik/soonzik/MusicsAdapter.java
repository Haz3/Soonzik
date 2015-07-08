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
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

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

        ImageView imageViewPicture = (ImageView) rowView.findViewById(R.id.albumpicture);
        imageViewPicture.setImageResource(R.drawable.ic_profile);

        TextView textViewArtist = (TextView) rowView.findViewById(R.id.musictitle);
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
                newFragment.show(((Activity)context).getFragmentManager(), "com.soonzik.soonzik.MusicActionDialogFragment");
            }
        });
        return rowView;
    }
}
