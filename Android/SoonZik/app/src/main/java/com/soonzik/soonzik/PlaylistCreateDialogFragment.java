package com.soonzik.soonzik;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.widget.EditText;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class PlaylistCreateDialogFragment extends DialogFragment {

    EditText playlistName;

    public interface NoticeDialogListener {
        public void onDialogPositiveClick(DialogFragment dialog);
        public void onDialogNegativeClick(DialogFragment dialog);
    }

    // Use this instance of the interface to deliver action events
    NoticeDialogListener mListener;

    // Override the Fragment.onAttach() method to instantiate the NoticeDialogListener
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        // Verify that the host activity implements the callback interface
        try {
            // Instantiate the NoticeDialogListener so we can send events to the host
            mListener = (NoticeDialogListener) activity;
        } catch (ClassCastException e) {
            // The activity doesn't implement the interface, throw exception
            throw new ClassCastException(activity.toString()
                    + " must implement NoticeDialogListener");
        }
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        LayoutInflater inflater = getActivity().getLayoutInflater();


        builder.setView(inflater.inflate(R.layout.dialog_create_playlist, null))
                .setPositiveButton(R.string.create_playlist_validate, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        final Dialog dial = (Dialog) dialog;
                        Map<String, String> tmp = new HashMap<String, String>();

                        playlistName = (EditText) dial.findViewById(R.id.playlistTitle);

                        tmp.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
                        tmp.put("name", playlistName.getText().toString());
                        ActiveRecord.save("Playlist", tmp, new ActiveRecord.OnJSONResponseCallback() {
                            @Override
                            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                                JSONObject obj = (JSONObject) response;

                                final Playlist playlist = (Playlist) ActiveRecord.jsonObjectData(obj, classT);
                                Log.v("PLAYLIST", playlist.toString());

                                mListener.onDialogPositiveClick(PlaylistCreateDialogFragment.this);
                            }
                        });
                    }
                })
                .setNegativeButton(R.string.cancel, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        PlaylistCreateDialogFragment.this.getDialog().cancel();
                        mListener.onDialogNegativeClick(PlaylistCreateDialogFragment.this);
                    }
                });


        return builder.create();
    }


}
