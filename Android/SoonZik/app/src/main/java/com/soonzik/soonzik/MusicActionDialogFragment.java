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
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 26/06/2015.
 */
public class MusicActionDialogFragment extends DialogFragment {

    private String[] choices = new String[] {"Add to playlist ...",  "Comment", "Rate", "Add to cart", "Share"};

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

                    final Music ms = (Music) ActiveRecord.jsonObjectData(obj, classT);

                    TextView musicTitle = (TextView) v.findViewById(R.id.title);
                    musicTitle.setText(ms.getTitle());

                    TextView albumTitle = (TextView) v.findViewById(R.id.albumtitle);
                    albumTitle.setText(ms.getAlbum().getTitle());

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
                                    DialogFragment frgDialogPlaylist = new PlaylistAddMusicDialogFragment();
                                    Bundle bundlePlaylist = new Bundle();
                                    bundlePlaylist.putInt("music_id", music_id);

                                    frgDialogPlaylist.setArguments(bundlePlaylist);
                                    frgDialogPlaylist.show(getActivity().getFragmentManager(), "com.soonzik.soonzik.PlaylistAddMusicDialogFragment");
                                    getDialog().dismiss();
                                    break;
                                case 1 : //comment
                                    Toast.makeText(getActivity(), "addcomment", Toast.LENGTH_SHORT).show();

                                    Bundle commentBundle = new Bundle();
                                    commentBundle.putString("class", "Music");
                                    commentBundle.putInt("to_comment_id", music_id);
                                    Fragment frgComment = Fragment.instantiate(getActivity(), "com.soonzik.soonzik.CommentaryListFragment");
                                    frgComment.setArguments(commentBundle);

                                    FragmentTransaction tx = ((FragmentActivity) getActivity()).getSupportFragmentManager().beginTransaction();
                                    tx.replace(R.id.main, frgComment);
                                    tx.addToBackStack(null);
                                    tx.commit();

                                    getDialog().dismiss();
                                    break;
                                case 2 : //rate
                                    Toast.makeText(getActivity(), "setnote", Toast.LENGTH_SHORT).show();

                                    DialogFragment frgDialogNote = new MusicNoteDialogFragment();
                                    Bundle bundleNote = new Bundle();
                                    bundleNote.putInt("music_id", music_id);
                                    bundleNote.putInt("note", ms.getGetAverageNote());

                                    frgDialogNote.setArguments(bundleNote);
                                    frgDialogNote.show(getActivity().getFragmentManager(), "com.soonzik.soonzik.MusicNoteDialogFragment");
                                    getDialog().dismiss();

                                    break;
                                case 3: //addtocart
                                    Toast.makeText(getActivity(), "addtocart", Toast.LENGTH_SHORT).show();
                                    final Map<String, String> data = new HashMap<String, String>();
                                    data.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
                                    data.put("typeObj", "Music");
                                    data.put("obj_id", Integer.toString(music_id));

                                    ActiveRecord.save("Cart", data, true, new ActiveRecord.OnJSONResponseCallback() {
                                        @Override
                                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                                            JSONObject obj = (JSONObject) response;

                                            Cart cart = (Cart) ActiveRecord.jsonObjectData(obj, classT);
                                            Toast.makeText(getActivity(), "Music add to cart", Toast.LENGTH_SHORT).show();
                                            getDialog().dismiss();
                                        }
                                    });
                                    break;
                                case 4: //share
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
