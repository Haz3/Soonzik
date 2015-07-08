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
 * Created by kevin_000 on 08/07/2015.
 */
public class TopFiveAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    public TopFiveAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_topfive, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_topfive, parent, false);
        final Music ms = (Music) values.get(position);

        ImageView imageViewPicture = (ImageView) rowView.findViewById(R.id.albumpicture);
        imageViewPicture.setImageResource(R.drawable.ic_explorer);

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

        return rowView;
    }
}
