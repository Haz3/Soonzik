package com.soonzik.testsupermodel;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class FriendsAdapter extends ArrayAdapter<Object> {

    private final Context context;
    private final List<Object> values;

    public FriendsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_friends, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_friends, parent, false);
        User nw = (User) values.get(position);
        TextView textView = (TextView) rowView.findViewById(R.id.label);

        textView.setText(nw.getUsername());

        return rowView;
    }
}
