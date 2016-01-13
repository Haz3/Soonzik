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
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Kevin on 2016-01-13.
 */
public class MusicContentAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    public MusicContentAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_musiccontent, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_musiccontent, parent, false);
        final Music ms = (Music) values.get(position);

        ImageView imageViewPicture = (ImageView) rowView.findViewById(R.id.albumpicture);
        imageViewPicture.setImageResource(R.drawable.ic_profile);

        TextView textViewArtist = (TextView) rowView.findViewById(R.id.artistname);
        textViewArtist.setText(ms.getUser().getUsername());

        textViewArtist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putInt("artist_id", ms.getUser().getId());
                Fragment frg = Fragment.instantiate(context, redirectClass);
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        TextView textViewTitle = (TextView) rowView.findViewById(R.id.title);
        textViewTitle.setText(ms.getTitle());

        ImageView downloadImageView = (ImageView) rowView.findViewById(R.id.download_imageView);
        downloadImageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Bundle bundle = new Bundle();
                bundle.putInt("music_id", ms.getId());
                bundle.putString("music_title", ms.getTitle());
                Fragment frg = Fragment.instantiate(context, "com.soonzik.soonzik.MusicDownloadFragment");
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        rowView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Bundle bundle = new Bundle();

                ArrayList<Integer> ids = new ArrayList<Integer>();
                ids.add(ms.getId());
                bundle.putIntegerArrayList("music_ids", ids);
                bundle.putInt("index_music", 0);

                ArrayList<String> artist_names = new ArrayList<String>();
                artist_names.add(ms.getUser().getUsername());
                bundle.putStringArrayList("artist_names", artist_names);

                ArrayList<String> title_songs = new ArrayList<String>();
                title_songs.add(ms.getTitle());
                bundle.putStringArrayList("title_songs", title_songs);

                ArrayList<String> title_albums = new ArrayList<String>();
                title_albums.add(ms.getAlbum().getTitle());
                bundle.putStringArrayList("title_albums", title_albums);

                ArrayList<String> image_albums = new ArrayList<String>();
                image_albums.add("http://soonzikapi.herokuapp.com/assets/albums/" + ms.getAlbum().getImage());
                bundle.putStringArrayList("image_albums", image_albums);


                Fragment frg = Fragment.instantiate(context, "com.soonzik.soonzik.Player");
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        return rowView;
    }
}
