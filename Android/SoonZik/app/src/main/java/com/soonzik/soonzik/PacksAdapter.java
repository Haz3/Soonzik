package com.soonzik.soonzik;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class PacksAdapter extends ArrayAdapter<Object> {

    private final Context context;
    private final List<Object> values;

    public PacksAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_packs, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_packs, parent, false);
        Pack pc = (Pack) values.get(position);

        ImageView imageViewPicture = (ImageView) rowView.findViewById(R.id.packpicture);
        imageViewPicture.setImageResource(R.drawable.ic_profile);

        ArrayList<Album> alb = pc.getAlbums();

        String arts = "";
        ArrayList<String> artistes = new ArrayList<String>();

        int nbalb = 0;
        if (alb != null) {
            nbalb = alb.size();
            String tmp = "";
            for (Album album : alb) {
                tmp = album.getUser().getUsername();
                if (!artistes.contains(tmp))
                    artistes.add(tmp);
            }
            int i = 1;
            for (String name : artistes) {
                arts += name;
                if (i < artistes.size())
                    arts += " / ";
                i++;
            }
        }

        TextView textViewArtists = (TextView) rowView.findViewById(R.id.albumtitle);
        textViewArtists.setText(arts);

        TextView textViewNbAlbums = (TextView) rowView.findViewById(R.id.nbalbums);
        textViewNbAlbums.setText(Integer.toString(nbalb));

        TextView textViewTitle = (TextView) rowView.findViewById(R.id.musictitle);
        textViewTitle.setText(pc.getTitle());
        return rowView;
    }
}
