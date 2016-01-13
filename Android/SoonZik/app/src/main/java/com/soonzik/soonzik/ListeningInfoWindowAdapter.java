package com.soonzik.soonzik;

import android.content.Context;
import android.support.v4.app.FragmentActivity;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.Marker;

/**
 * Created by Kevin on 2016-01-11.
 */
public class ListeningInfoWindowAdapter implements GoogleMap.InfoWindowAdapter {

    private final View mContents;
    private Listening mListening;

    ListeningInfoWindowAdapter(Context context, Listening listening) {
        mContents = ((FragmentActivity) context).getLayoutInflater().inflate(R.layout.infowindow_listening, null);
        mListening = listening;
    }

    @Override
    public View getInfoWindow(Marker marker) {
        return null;
    }

    @Override
    public View getInfoContents(Marker marker) {
        new Utils.ImageLoadTask("http://soonzikapi.herokuapp.com/assets/albums/" + mListening.getMusic().getAlbum().getImage(), (ImageView) mContents.findViewById(R.id.albumpicture)).execute();

        TextView textViewArtist = (TextView) mContents.findViewById(R.id.artistname);
        textViewArtist.setText(mListening.getMusic().getUser().getUsername());

        TextView textViewTitle = (TextView) mContents.findViewById(R.id.title);
        textViewTitle.setText(mListening.getMusic().getTitle());
        return mContents;
    }
}
