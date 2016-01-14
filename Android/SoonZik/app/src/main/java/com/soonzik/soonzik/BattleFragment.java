package com.soonzik.soonzik;

import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.TimeUnit;

/**
 * Created by kevin_000 on 13/05/2015.
 */
public class BattleFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.BattleFragment";
    private String redirectClassArtist = "com.soonzik.soonzik.BattleFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_battle,
                container, false);

        final int id = this.getArguments().getInt("battle_id");

        try {
            ActiveRecord.show("Battle", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    final Battle battle = (Battle) ActiveRecord.jsonObjectData(data, classT);

                    int user_vote = -1;
                    int nb_vote_one = 0;
                    int nb_vote_two = 0;

                    for (Vote vt : battle.getVotes()) {
                        if (vt.getUser_id() == ActiveRecord.currentUser.getId()) {
                            user_vote = vt.getArtist_id();
                        }
                        if (vt.getArtist_id() == battle.getArtistOne().getId()) {
                            nb_vote_one++;
                        }
                        else {
                            nb_vote_two++;
                        }
                    }

                    TextView textViewUserVote = (TextView) view.findViewById(R.id.uservote);

                    if (user_vote != -1 && user_vote == battle.getArtistOne().getId()) {
                        textViewUserVote.setText(battle.getArtistOne().getUsername());
                    }
                    else if (user_vote != -1 && user_vote == battle.getArtistTwo().getId()) {
                        textViewUserVote.setText(battle.getArtistTwo().getUsername());
                    }
                    else {
                        textViewUserVote.setText("You haven't already vote!");
                    }

                    TextView textViewUserOneVote = (TextView) view.findViewById(R.id.artistonevote);
                    textViewUserOneVote.setText(Integer.toString(nb_vote_one));

                    TextView textViewUserTwoVote = (TextView) view.findViewById(R.id.artisttwovote);
                    textViewUserTwoVote.setText(Integer.toString(nb_vote_two));

                    ImageView imageViewArtistOne = (ImageView) view.findViewById(R.id.artistonepicture);
                    imageViewArtistOne.setImageResource(R.drawable.ic_profile);

                    ImageView imageViewArtistTwo = (ImageView) view.findViewById(R.id.artisttwopicture);
                    imageViewArtistTwo.setImageResource(R.drawable.ic_profile);

                    TextView timeRemaining = (TextView) view.findViewById(R.id.timeremaining);

                    Date time = new Date();

                    long diff = battle.getDate_end().getTime() - time.getTime();
                    long hour = TimeUnit.MILLISECONDS.toHours(diff);

                    if (TimeUnit.MICROSECONDS.toSeconds(diff) <= 0) {
                        timeRemaining.setText("Times up!");
                    }
                    else if (hour < 1) {
                        timeRemaining.setText("< 1 Hours");
                    }
                    else {
                        timeRemaining.setText(Long.toString(hour) + " Hours");
                    }

                    TextView nameartistone = (TextView) view.findViewById(R.id.nameartistone);
                    nameartistone.setText(battle.getArtistOne().getUsername());

                    nameartistone.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Bundle bundle = new Bundle();
                            bundle.putInt("artist_id", battle.getArtistOne().getId());
                            Fragment frg = Fragment.instantiate(getActivity(), redirectClassArtist);
                            frg.setArguments(bundle);

                            FragmentTransaction tx = (getActivity()).getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
                            tx.addToBackStack(null);
                            tx.commit();
                        }
                    });

                    TextView nameartisttwo = (TextView) view.findViewById(R.id.nameartisttwo);
                    nameartisttwo.setText(battle.getArtistTwo().getUsername());

                    nameartisttwo.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Bundle bundle = new Bundle();
                            bundle.putInt("artist_id", battle.getArtistTwo().getId());
                            Fragment frg = Fragment.instantiate(getActivity(), redirectClassArtist);
                            frg.setArguments(bundle);

                            FragmentTransaction tx = (getActivity()).getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
                            tx.addToBackStack(null);
                            tx.commit();
                        }
                    });

                    Artist.isArtist(battle.getArtistOne().getId(), new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                            final Artist art = (Artist) ActiveRecord.jsonObjectData((JSONObject) response, classT);

                            ArrayList<Music> ms = art.getTopFive();
                            for (Music m : ms) {
                                m.setUser(battle.getArtistOne());
                            }

                            final ArrayList<Object> sg = new ArrayList<Object>(ms);

                            TopFiveAdapter topFiveAdapter = new TopFiveAdapter(getActivity(), sg);
                            ListView lv = (ListView) getActivity().findViewById(R.id.topartistone);
                            lv.setAdapter(topFiveAdapter);

                            lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                @Override
                                public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                                    MediaPlayer mediaPlayer;

                                    mediaPlayer = new MediaPlayer();
                                    mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);

                                    try {
                                        mediaPlayer.setDataSource(ActiveRecord.serverLink + "musics/get/1");
                                        mediaPlayer.prepare();
                                        mediaPlayer.start();
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                }
                            });

                        }
                    });


                    Artist.isArtist(battle.getArtistTwo().getId(), new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                            final Artist art = (Artist) ActiveRecord.jsonObjectData((JSONObject) response, classT);

                            ArrayList<Music> ms = art.getTopFive();
                            for (Music m : ms) {
                                m.setUser(battle.getArtistTwo());
                            }

                            final ArrayList<Object> sg = new ArrayList<Object>(ms);

                            TopFiveAdapter topFiveAdapter = new TopFiveAdapter(getActivity(), sg);
                            ListView lv = (ListView) getActivity().findViewById(R.id.topartisttwo);
                            lv.setAdapter(topFiveAdapter);

                            lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                                @Override
                                public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                                    MediaPlayer mediaPlayer;

                                    mediaPlayer = new MediaPlayer();
                                    mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);

                                    try {
                                        mediaPlayer.setDataSource(ActiveRecord.serverLink + "musics/get/1");
                                        mediaPlayer.prepare();
                                        mediaPlayer.start();
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                    }
                                }
                            });

                        }
                    });

                    new SwipeDetector(view).setOnSwipeListener(new SwipeDetector.onSwipeEvent() {
                        @Override
                        public void SwipeEventDetected(View v, SwipeDetector.SwipeTypeEnum swipeType) {
                            if (swipeType == SwipeDetector.SwipeTypeEnum.LEFT_TO_RIGHT) {
                                Battle.vote(id, battle.getArtistOne().getId(), new ActiveRecord.OnJSONResponseCallback() {
                                    @Override
                                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {

                                        Bundle bundle = new Bundle();
                                        bundle.putInt("battle_id", id);
                                        Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                                        frg.setArguments(bundle);

                                        FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                                        tx.replace(R.id.main, frg);
                                        tx.addToBackStack(null);
                                        tx.commit();
                                    }
                                });
                            } else if (swipeType == SwipeDetector.SwipeTypeEnum.RIGHT_TO_LEFT) {
                                Battle.vote(id, battle.getArtistTwo().getId(), new ActiveRecord.OnJSONResponseCallback() {
                                    @Override
                                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {

                                        Bundle bundle = new Bundle();
                                        bundle.putInt("battle_id", id);
                                        Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                                        frg.setArguments(bundle);

                                        FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                                        tx.replace(R.id.main, frg);
                                        tx.addToBackStack(null);
                                        tx.commit();
                                    }
                                });
                            }
                        }
                    });


                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }



        return view;
    }

}
