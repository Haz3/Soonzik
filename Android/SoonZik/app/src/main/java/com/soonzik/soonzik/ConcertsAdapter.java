package com.soonzik.soonzik;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.text.Html;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import org.json.JSONException;

import java.lang.reflect.InvocationTargetException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by Kevin on 2015-08-30.
 */
public class ConcertsAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    public ConcertsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_concerts, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_concerts, parent, false);
        final Concert ct = (Concert) values.get(position);

        /*ImageView imageViewPicture = (ImageView) rowView.findViewById(R.id.userpicture);
        imageViewPicture.setImageResource(R.drawable.ic_profile);*/

        new Utils.ImageLoadTask("http://soonzikapi.herokuapp.com/assets/usersImage/avatars/" + ct.getUser().getImage(), (ImageView) rowView.findViewById(R.id.userpicture)).execute();

        final ImageView likedConcert = (ImageView) rowView.findViewById(R.id.concert_like);
        final TextView nbLikes = (TextView) rowView.findViewById(R.id.nb_likes);
        nbLikes.setText(Integer.toString(ct.getLikes()));

        if (ct.isHasLiked()) {
            likedConcert.setImageResource(R.drawable.like);
        } else {
            likedConcert.setImageResource(R.drawable.unlike);
        }
        
        likedConcert.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (ct.isHasLiked()) {
                    User.unlikeContent("Concerts", ct.getId(), new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                            likedConcert.setImageResource(R.drawable.unlike);
                            ct.setHasLiked(!ct.isHasLiked());
                            ct.setLikes(ct.getLikes() - 1);
                            nbLikes.setText(Integer.toString(ct.getLikes()));
                        }
                    });
                } else {
                    User.likeContent("Concerts", ct.getId(), new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                            likedConcert.setImageResource(R.drawable.like);
                            ct.setHasLiked(!ct.isHasLiked());
                            ct.setLikes(ct.getLikes() + 1);
                            nbLikes.setText(Integer.toString(ct.getLikes()));
                        }
                    });
                }
            }
        });

        TextView textViewArtist = (TextView) rowView.findViewById(R.id.artistconcert);
        textViewArtist.setText(ct.getUser().getUsername());

        textViewArtist.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putInt("artist_id", ct.getUser().getId());
                Fragment frg = Fragment.instantiate(context, redirectClass);
                frg.setArguments(bundle);

                FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, frg);
                tx.addToBackStack(null);
                tx.commit();
            }
        });

        TextView textViewDate = (TextView) rowView.findViewById(R.id.dateconcert);
        //DateFormat dateFormat = android.text.format.DateFormat.getDateFormat(context);
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yy HH:mm");
        textViewDate.setText(dateFormat.format(ct.getPlanification()));

        TextView textViewLink = (TextView) rowView.findViewById(R.id.linkconcert);
        textViewLink.setText("https://www.facebook.com/soonzik");

        TextView textViewAddress = (TextView) rowView.findViewById(R.id.adressconcert);
        textViewAddress.setText(ct.getAddress().formatAddress());

        return rowView;
    }
}
