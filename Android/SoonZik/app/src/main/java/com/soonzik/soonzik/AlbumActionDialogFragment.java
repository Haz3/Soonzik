package com.soonzik.soonzik;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
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
 * Created by Kevin on 2015-10-31.
 */
public class AlbumActionDialogFragment extends DialogFragment {

    private String[] choices = new String[] {"Comment", "Add to cart", "Share"};

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        LayoutInflater inflater = getActivity().getLayoutInflater();
        final View v = inflater.inflate(R.layout.dialog_action_album, null);

        final int album_id = this.getArguments().getInt("album_id");

        Log.v("ALBUM_ID 2", Integer.toString(album_id));

        try {
            ActiveRecord.show("Album", album_id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject obj = (JSONObject) response;

                    final Album alb = (Album) ActiveRecord.jsonObjectData(obj, classT);

                    TextView albumTitle = (TextView) v.findViewById(R.id.title);
                    albumTitle.setText(alb.getTitle());

                    TextView artistName = (TextView) v.findViewById(R.id.artistname);
                    artistName.setText(alb.getUser().getUsername());

                    ListView lv = (ListView) v.findViewById(R.id.listviewchoice);
                    lv.setAdapter(new ArrayAdapter<String>(getActivity(),
                            android.R.layout.simple_list_item_1,
                            android.R.id.text1, choices));

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                            switch (position) {
                                case 0 : //comment
                                    Toast.makeText(getActivity(), "addcomment", Toast.LENGTH_SHORT).show();

                                    Bundle commentBundle = new Bundle();
                                    commentBundle.putString("class", "Album");
                                    commentBundle.putInt("to_comment_id", album_id);
                                    Fragment frgComment = Fragment.instantiate(getActivity(), "com.soonzik.soonzik.CommentaryListFragment");
                                    frgComment.setArguments(commentBundle);

                                    FragmentTransaction tx = ((FragmentActivity) getActivity()).getSupportFragmentManager().beginTransaction();
                                    tx.replace(R.id.main, frgComment);
                                    tx.addToBackStack(null);
                                    tx.commit();

                                    getDialog().dismiss();
                                    break;
                                case 1: //addtocart
                                    Toast.makeText(getActivity(), "addtocart", Toast.LENGTH_SHORT).show();
                                    final Map<String, String> data = new HashMap<String, String>();
                                    data.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
                                    data.put("typeObj", "Album");
                                    data.put("obj_id", Integer.toString(album_id));

                                    ActiveRecord.save("Cart", data, new ActiveRecord.OnJSONResponseCallback() {
                                        @Override
                                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                                            JSONObject obj = (JSONObject) response;

                                            Cart cart = (Cart) ActiveRecord.jsonObjectData(obj, classT);
                                            Toast.makeText(getActivity(), "Album add to cart", Toast.LENGTH_SHORT).show();
                                            getDialog().dismiss();
                                        }
                                    });
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
