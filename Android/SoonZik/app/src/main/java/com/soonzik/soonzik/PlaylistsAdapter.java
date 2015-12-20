package com.soonzik.soonzik;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

/**
 * Created by kevin_000 on 13/05/2015.
 */
public class PlaylistsAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    public PlaylistsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_playlists, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_playlists, parent, false);
        Playlist pl = (Playlist) values.get(position);

        TextView titlePlaylist = (TextView) rowView.findViewById(R.id.label);
        titlePlaylist.setText(pl.getName());
        TextView nbTitle = (TextView) rowView.findViewById(R.id.nbTitle);
        nbTitle.setText(Integer.toString(pl.getMusics().size()));
        return rowView;
    }

}
