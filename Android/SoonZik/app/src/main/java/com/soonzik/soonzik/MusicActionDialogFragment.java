package com.soonzik.soonzik;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.app.Fragment;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 26/06/2015.
 */
public class MusicActionDialogFragment extends DialogFragment {

    private String[] choices = new String[] {"Add to playlist ...", "Add to cart", "Share"};

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        LayoutInflater inflater = getActivity().getLayoutInflater();
        final View v = inflater.inflate(R.layout.dialog_action_music, null);

        final int music_id = this.getArguments().getInt("music_id");

        try {
            ActiveRecord.show("Music", music_id, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject obj = (JSONObject) response;

                    Music ms = (Music) ActiveRecord.jsonObjectData(obj, classT);

                    TextView musicTitle = (TextView) v.findViewById(R.id.musictitle);
                    musicTitle.setText(ms.getTitle());

                    TextView albumTitle = (TextView) v.findViewById(R.id.albumtitle);
                    albumTitle.setText(ms.getTitle());

                    TextView artistName = (TextView) v.findViewById(R.id.artistname);
                    artistName.setText(ms.getUser().getUsername());

                    ListView lv = (ListView) v.findViewById(R.id.listviewchoice);
                    lv.setAdapter(new ArrayAdapter<String>(getActivity(),
                            android.R.layout.simple_list_item_1,
                            android.R.id.text1, choices));

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                            switch (position) {
                                case 0: //addtoplaylist
                                    Toast.makeText(getActivity(), "addtoplaylist", Toast.LENGTH_SHORT).show();
                                    DialogFragment frg = new PlaylistAddMusicDialogFragment();
                                    Bundle bundle = new Bundle();
                                    bundle.putInt("music_id", music_id);

                                    frg.setArguments(bundle);
                                    frg.show(getActivity().getFragmentManager(), "com.soonzik.soonzik.PlaylistAddMusicDialogFragment");
                                    getDialog().dismiss();
                                    break;
                                case 1: //addtocart
                                    Toast.makeText(getActivity(), "addtocart", Toast.LENGTH_SHORT).show();
                                    break;
                                case 2: //share
                                    Toast.makeText(getActivity(), "share", Toast.LENGTH_SHORT).show();
                                    break;
                                default:
                                    break;
                            }
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
