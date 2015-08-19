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

import org.json.JSONException;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

/**
 * Created by kevin_000 on 13/08/2015.
 */
public class CartsAdapter extends ArrayAdapter<Object> {

    private final Context context;
    private final List<Object> values;

    private String redirectClass = "com.soonzik.soonzik.ArtistFragment";

    public CartsAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_battles, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        final Cart ct = (Cart) values.get(position);
        View rowView = inflater.inflate(R.layout.row_cart_musics, parent, false);

        if (ct.getMusics() != null && ct.getMusics().size() > 0) {
            final Music ms = ct.getMusics().get(0);

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

            TextView price = (TextView) rowView.findViewById(R.id.price);
            price.setText(Double.toString(ms.getPrice()) + "$");
        }
        else if (ct.getAlbums() != null && ct.getAlbums().size() > 0) {
            rowView = inflater.inflate(R.layout.row_cart_albums, parent, false);
            final Album alb = ct.getAlbums().get(0);

            ImageView imageViewPicture = (ImageView) rowView.findViewById(R.id.albumpicture);
            imageViewPicture.setImageResource(R.drawable.ic_profile);

            TextView textViewArtist = (TextView) rowView.findViewById(R.id.artistname);
            textViewArtist.setText(alb.getUser().getUsername());

            textViewArtist.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Bundle bundle = new Bundle();
                    bundle.putInt("artist_id", alb.getUser().getId());
                    Fragment frg = Fragment.instantiate(context, redirectClass);
                    frg.setArguments(bundle);

                    FragmentTransaction tx = ((FragmentActivity) context).getSupportFragmentManager().beginTransaction();
                    tx.replace(R.id.main, frg);
                    tx.addToBackStack(null);
                    tx.commit();
                }
            });

            TextView textViewTitle = (TextView) rowView.findViewById(R.id.title);
            textViewTitle.setText(alb.getTitle());

            TextView albumPrice = (TextView) rowView.findViewById(R.id.price);
            albumPrice.setText(Double.toString(alb.getPrice()) + "$");
        }

        TextView deletebutton = (TextView) rowView.findViewById(R.id.deletebutton);
        deletebutton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ActiveRecord.destroy("Cart", ct.getId(), new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, InstantiationException, IllegalAccessException, JSONException {

                    }
                });
            }
        });
        return rowView;
    }
}
