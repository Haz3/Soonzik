package com.soonzik.soonzik;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 05/05/2015.
 */
public class NewsAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    public NewsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_news, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_news, parent, false);
        News nw = (News) values.get(position);

        TextView textViewTitle = (TextView) rowView.findViewById(R.id.title);
        textViewTitle.setText(nw.getTitle());

        TextView textViewDate = (TextView) rowView.findViewById(R.id.date);

        DateFormat dateFormat = android.text.format.DateFormat.getDateFormat(context);

        textViewDate.setText(dateFormat.format(nw.getDate()));

        TextView textViewContent = (TextView) rowView.findViewById(R.id.content);
        ArrayList<Newstext> texts = nw.getNewstexts();
        for (Newstext text : texts) {
            if (text.getLanguage().equals("FR")) {
                textViewContent.setText(text.getContent());
            }
        }
        return rowView;
    }
}
