package com.soonzik.soonzik;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by Kevin on 2015-08-30.
 */
public class ConcertsAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    public ConcertsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_concerts, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_concerts, parent, false);
        final Concert ct = (Concert) values.get(position);

        ImageView imageViewPicture = (ImageView) rowView.findViewById(R.id.concertpicture);
        imageViewPicture.setImageResource(R.drawable.ic_profile);

        TextView textViewArtist = (TextView) rowView.findViewById(R.id.artistconcert);
        textViewArtist.setText(ct.getUser().getUsername());

        textViewArtist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putInt("artist_id", ct.getUser().getId());
                Fragment frg = Fragment.instantiate(context, redirectClass);
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        TextView textViewDate = (TextView) rowView.findViewById(R.id.dateconcert);
        //DateFormat dateFormat = android.text.format.DateFormat.getDateFormat(context);
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yy HH:mm");
        textViewDate.setText(dateFormat.format(ct.getPlanification()));

        TextView textViewLink = (TextView) rowView.findViewById(R.id.linkconcert);
        textViewLink.setText("https://www.facebook.com/soonzik");

        TextView textViewAddress = (TextView) rowView.findViewById(R.id.adressconcert);
        textViewAddress.setText(ct.getAddress().formatAddress());

        return rowView;
    }
}
