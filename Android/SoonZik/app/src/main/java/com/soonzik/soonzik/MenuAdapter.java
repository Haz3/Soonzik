package com.soonzik.soonzik;

import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 10/06/2015.
 */
public class MenuAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final String[] values;
    private final String[] icons;
    private final Resources resources;

    public MenuAdapter(Context context, String[] names, String[] m_icons) {
        super(context, R.layout.row_menu, names);
        this.context = context;
        this.values = names;
        this.icons = m_icons;
        this.resources = context.getResources();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_menu, parent, false);
        TextView textView = (TextView) rowView.findViewById(R.id.label);
        textView.setText(this.values[position]);

        ImageView img = (ImageView) rowView.findViewById(R.id.imageMenu);
        img.setImageResource(resources.getIdentifier(icons[position], "drawable", context.getPackageName()));

        return rowView;
    }
}
