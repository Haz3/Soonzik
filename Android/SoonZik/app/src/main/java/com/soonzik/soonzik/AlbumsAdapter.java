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
 * Created by kevin_000 on 12/06/2015.
 */
public class AlbumsAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    public AlbumsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_battles, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_albums, parent, false);
        final Album al = (Album) values.get(position);

        List<Object> ms = new ArrayList<Object>(al.getMusics());
        User art = al.getUser();
        if (art != null) {
            for (Object m : ms) {
                ((Music) m).setUser(art);
            }
        }

        TextView title = (TextView) rowView.findViewById(R.id.albumtitle);
        title.setText(al.getTitle());

        TextView artistname = (TextView) rowView.findViewById(R.id.artistname);
        artistname.setText(al.getUser().getUsername());

        artistname.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putInt("artist_id", al.getUser().getId());
                Fragment frg = Fragment.instantiate(context, redirectClass);
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        TextView nbTitle = (TextView) rowView.findViewById(R.id.nbtitle);
        nbTitle.setText(Integer.toString(ms.size()));

        ImageView likedAlbum = (ImageView) rowView.findViewById(R.id.album_like);
        TextView nbLikes = (TextView) rowView.findViewById(R.id.nb_likes);
        nbLikes.setText(Integer.toString(al.getLikes()));

        if (al.isHasLiked()) {
            likedAlbum.setImageResource(R.drawable.like);
        } else {
            likedAlbum.setImageResource(R.drawable.unlike);
        }

        new Utils.ImageLoadTask("http://soonzikapi.herokuapp.com/assets/albums/" + al.getImage(), (ImageView) rowView.findViewById(R.id.albumpicture)).execute();


        return rowView;
    }
}
