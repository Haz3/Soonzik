package com.soonzik.soonzik;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RatingBar;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 26/06/2015.
 */
public class MusicNoteDialogFragment extends DialogFragment {

    private String redirectClass = "com.soonzik.soonzik.PlaylistFragment";

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        LayoutInflater inflater = getActivity().getLayoutInflater();
        final View v = inflater.inflate(R.layout.dialog_note_music, null);

        final int id_music = this.getArguments().getInt("music_id");
        int note = this.getArguments().getInt("note");

        final RatingBar ratingBar = (RatingBar) v.findViewById(R.id.ratingbarmusic);

        ratingBar.setNumStars(5);
        ratingBar.setRating(note);

        Button rateSend = (Button) v.findViewById(R.id.sendnote);

        rateSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Music.setNotes(id_music, Math.round(ratingBar.getRating()), new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                        getDialog().dismiss();
                    }
                });
            }
        });


        builder.setView(v);
        return builder.create();
    }
}
