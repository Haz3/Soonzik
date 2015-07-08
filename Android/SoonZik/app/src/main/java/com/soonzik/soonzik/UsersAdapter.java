package com.soonzik.soonzik;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

/**
 * Created by kevin_000 on 02/06/2015.
 */
public class UsersAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    public UsersAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_users, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_users, parent, false);
        User us = (User) values.get(position);

        TextView textView = (TextView) rowView.findViewById(R.id.label);

        textView.setText(us.getUsername());
        return rowView;
    }
}
