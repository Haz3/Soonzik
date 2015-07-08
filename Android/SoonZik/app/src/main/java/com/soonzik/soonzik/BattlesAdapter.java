package com.soonzik.soonzik;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class BattlesAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    public BattlesAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_battles, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_battles, parent, false);
        Battle bt = (Battle) values.get(position);
        TextView textView = (TextView) rowView.findViewById(R.id.label);

        User artist_one = bt.getArtistOne();
        User artist_two = bt.getArtistTwo();

        textView.setText(artist_one.getUsername() + " / " + artist_two.getUsername());

        TextView nbVote = (TextView) rowView.findViewById(R.id.nbvote);

        int vote_one = 0;
        int vote_two = 0;

        for (Vote vt : bt.getVotes()) {
            if (vt.getArtist_id() == bt.getArtistOne().getId()) {
                vote_one++;
            }
            else {
                vote_two++;
            }
        }

        nbVote.setText(Integer.toString(vote_one) + " / " + Integer.toString(vote_two));

        TextView timeRemaining = (TextView) rowView.findViewById(R.id.timeremaining);

        Date time = new Date();

        long diff = bt.getDate_end().getTime() - time.getTime();
        long hour = TimeUnit.MILLISECONDS.toHours(diff);

        if (TimeUnit.MICROSECONDS.toSeconds(diff) <= 0) {
            timeRemaining.setText("Times up!");
        }
        else if (hour < 1) {
            timeRemaining.setText("< 1 Hours");
        }
        else {
            timeRemaining.setText(Long.toString(hour) + " Hours");
        }

        return rowView;
    }
}
