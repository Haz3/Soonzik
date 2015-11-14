package com.soonzik.soonzik;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

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

        ArrayList<Attachment> attachments = nw.getAttachments();
        boolean imgOk = false;
        for (Attachment at : attachments) {
            if (!imgOk) {
                new Utils.ImageLoadTask("http://soonzikapi.herokuapp.com/assets/news/" + at.getUrl(), (ImageView) rowView.findViewById(R.id.imageNews)).execute();
                imgOk = true;
            }
        }

        TextView textViewTitle = (TextView) rowView.findViewById(R.id.title);
        textViewTitle.setText(nw.getTitle());

        TextView textViewDate = (TextView) rowView.findViewById(R.id.date);
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yy HH:mm", new Locale("FR"));
        textViewDate.setText(dateFormat.format(nw.getCreated_at()));

        ImageView likedAlbum = (ImageView) rowView.findViewById(R.id.news_like);
        TextView nbLikes = (TextView) rowView.findViewById(R.id.nb_likes);
        nbLikes.setText(Integer.toString(nw.getLikes()));

        if (nw.isHasLiked()) {
            likedAlbum.setImageResource(R.drawable.like);
        } else {
            likedAlbum.setImageResource(R.drawable.unlike);
        }
        return rowView;
    }
}
