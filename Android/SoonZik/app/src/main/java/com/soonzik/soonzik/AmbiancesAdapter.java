package com.soonzik.soonzik;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Created by Kevin on 2016-01-07.
 */
public class AmbiancesAdapter  extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    public AmbiancesAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_ambiances, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_ambiances, parent, false);

        Ambiance ab = (Ambiance) values.get(position);

        TextView name = (TextView) rowView.findViewById(R.id.ambiancename);
        name.setText(ab.getName());

        return rowView;
    }
}
