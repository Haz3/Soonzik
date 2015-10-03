package com.soonzik.soonzik;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

/**
 * Created by Kevin on 2015-08-30.
 */
public class TweetsAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    private String redirectClass = "com.soonzik.soonzik.UserFragment";

    public TweetsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_tweets, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_tweets, parent, false);
        final Tweet tt = (Tweet) values.get(position);

        TextView textViewUsername = (TextView) rowView.findViewById(R.id.username);
        textViewUsername.setText(tt.getUser().getUsername());

        textViewUsername.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putInt("user_id", tt.getUser().getId());
                Fragment frg = Fragment.instantiate(context, redirectClass);
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        TextView textViewDate = (TextView) rowView.findViewById(R.id.datetweet);
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yy HH:mm", new Locale("FR"));
        textViewDate.setText(dateFormat.format(tt.getCreated_at()));

        TextView textViewTweet = (TextView) rowView.findViewById(R.id.contenttweet);
        textViewTweet.setText(tt.getMsg());

        return rowView;
    }
}