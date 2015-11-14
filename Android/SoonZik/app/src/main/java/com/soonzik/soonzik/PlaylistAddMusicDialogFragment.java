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
import android.widget.ListView;

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 26/06/2015.
 */
public class PlaylistAddMusicDialogFragment extends DialogFragment {

    private String redirectClass = "com.soonzik.soonzik.PlaylistFragment";

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        LayoutInflater inflater = getActivity().getLayoutInflater();
        final View v = inflater.inflate(R.layout.dialog_add_to_playlist, null);

        final int id_music = this.getArguments().getInt("music_id");

        Map<String, Object> linkparams = new HashMap<String, Object>();
        Map<String, String> attribute = new HashMap<String, String>();
        attribute.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
        linkparams.put("attribute", attribute);
        try {
            ActiveRecord.find("Playlist", linkparams, new ActiveRecord.OnJSONResponseCallback() {

                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> playlists = ActiveRecord.jsonArrayData(data, classT);

                    PlaylistsAdapter playlistsAdapter = new PlaylistsAdapter(getActivity(), playlists);

                    ListView lv = (ListView) v.findViewById(R.id.listviewplaylist);
                    lv.setAdapter(playlistsAdapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                            final Playlist pl = (Playlist) playlists.get(position);

                            Music.addToPlaylist(id_music, pl.getId(), new ActiveRecord.OnJSONResponseCallback() {
                                @Override
                                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                                    Bundle bundle = new Bundle();
                                    bundle.putInt("playlist_id", pl.getId());
                                    Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                                    frg.setArguments(bundle);

                                    getDialog().dismiss();
                                    FragmentTransaction tx = ((FragmentActivity) getActivity()).getSupportFragmentManager().beginTransaction();
                                    tx.replace(R.id.main, frg);
                                    tx.addToBackStack(null);
                                    tx.commit();
                                }
                            });
                        }
                    });
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        builder.setView(v);
        return builder.create();
    }
}
