package com.soonzik.soonzik;

import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

/**
 * Created by kevin_000 on 05/06/2015.
 */
public class Player extends Fragment {

    private ImageView prev, next, play, pause;
    private ImageView imageAlbum;
    private MediaPlayer mediaPlayer;
    private double startTime = 0;
    private double finalTime = 0;
    private Handler myHandler = new Handler();;
    private int forwardTime = 5000;
    private int backwardTime = 5000;
    private SeekBar seekbar;
    private TextView artistName, musicCurrentTime, musicDuration, title;
    private int index_music = 0;
    private ArrayList<Integer> ids;
    private ArrayList<String> artist_names, title_songs, title_albums, image_albums;

    public static int oneTimeOnly = 0;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        final View v = inflater.inflate(R.layout.fragment_player, container, false);

        init_getViewElement(v);
        init();
        init_contentElementView();
        prepareMediaplayer();

        play.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mediaPlayer.start();
                startTime = mediaPlayer.getCurrentPosition();

                if (oneTimeOnly == 0) {
                    seekbar.setMax((int) finalTime);
                    oneTimeOnly = 1;
                }
                displayTime();

                seekbar.setMax((int) finalTime);
                seekbar.setProgress((int) startTime);
                myHandler.postDelayed(UpdateSongTime, 100);
                pause.setEnabled(true);
                play.setEnabled(false);
            }
        });

        pause.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mediaPlayer.pause();
                pause.setEnabled(false);
                play.setEnabled(true);
            }
        });

        next.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if (index_music == (ids.size() - 1))
                    index_music = 0;
                else
                    index_music++;
                init_contentElementView();
                prepareMediaplayer();

            }
        });

        prev.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (index_music == 0)
                    index_music = ids.size() - 1;
                else
                    index_music--;
                init_contentElementView();
                prepareMediaplayer();

            }
        });
        return v;
    }

    private Runnable UpdateSongTime = new Runnable() {
        public void run() {
            startTime = mediaPlayer.getCurrentPosition();

            long min = TimeUnit.MILLISECONDS.toMinutes((long) startTime);
            long sec = TimeUnit.MILLISECONDS.toSeconds((long) startTime) -
                    TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.
                            toMinutes((long) startTime));

            if (sec < 10)
                musicCurrentTime.setText(String.format("%d:0%d", min , sec));
            else
                musicCurrentTime.setText(String.format("%d:%d", min, sec));
            seekbar.setProgress((int) startTime);
            myHandler.postDelayed(this, 100);
        }
    };

    private void init() {
        ids = getArguments().getIntegerArrayList("music_ids");
        index_music = getArguments().getInt("index_music");
        Log.v("PLAYER", Integer.toString(index_music));
        artist_names = getArguments().getStringArrayList("artist_names");
        title_songs = getArguments().getStringArrayList("title_songs");
        title_albums = getArguments().getStringArrayList("title_albums");
        image_albums = getArguments().getStringArrayList("image_albums");
        mediaPlayer = ActiveRecord.mediaPlayer;
    }

    private void init_getViewElement(View v) {
        artistName = (TextView) v.findViewById(R.id.artistName);

        prev = (ImageView) v.findViewById(R.id.prev);
        next = (ImageView) v.findViewById(R.id.next);
        play = (ImageView) v.findViewById(R.id.play);
        pause = (ImageView) v.findViewById(R.id.pause);

        imageAlbum = (ImageView)v.findViewById(R.id.imageAlbum);

        musicCurrentTime =(TextView)v.findViewById(R.id.musicCurrentTime);
        musicDuration =(TextView)v.findViewById(R.id.musicDuration);
        title =(TextView)v.findViewById(R.id.musicTitle);

        seekbar = (SeekBar) v.findViewById(R.id.seekBar);
    }

    private void init_contentElementView() {
        artistName.setText(artist_names.get(index_music));
        title.setText(title_songs.get(index_music));
        new Utils.ImageLoadTask(image_albums.get(index_music), imageAlbum).execute();
    }

    private void displayTime() {
        long min = TimeUnit.MILLISECONDS.toMinutes((long) finalTime);
        long sec = TimeUnit.MILLISECONDS.toSeconds((long) finalTime) -
                TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long) finalTime));

        if (sec < 10)
            musicDuration.setText(String.format("%d:0%d", min , sec));
        else
            musicDuration.setText(String.format("%d:%d", min, sec));

        min = TimeUnit.MILLISECONDS.toMinutes((long) startTime);
        sec = TimeUnit.MILLISECONDS.toSeconds((long) startTime) -
                TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long) startTime));

        if (sec < 10)
            musicCurrentTime.setText(String.format("%d:0%d", min , sec));
        else
            musicCurrentTime.setText(String.format("%d:%d", min, sec));
    }

    private void prepareMediaplayer() {
        if (ActiveRecord.currentUser != null) {
            assert ids != null;

            Music.getSecureUrl(ids.get(index_music), new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    try {
                        Log.v("PLAYER", response.toString());
                        mediaPlayer.reset();
                        mediaPlayer.setDataSource(response.toString());
                        mediaPlayer.prepareAsync();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
        else {
            try {
                mediaPlayer.reset();
                mediaPlayer.setDataSource(ActiveRecord.serverLink + "musics/get/" + Integer.toString(ids.get(index_music)));
                mediaPlayer.prepareAsync();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        mediaPlayer.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mp) {
                mediaPlayer.start();
                finalTime = mediaPlayer.getDuration();
                startTime = mediaPlayer.getCurrentPosition();
                displayTime();
                seekbar.setMax((int) finalTime);
                myHandler.postDelayed(UpdateSongTime, 100);
            }
        });

        mediaPlayer.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mediaPlayer) {
                if (index_music == (ids.size() - 1))
                    index_music = 0;
                else
                    index_music++;
                init_contentElementView();
                mediaPlayer.reset();
                prepareMediaplayer();
            }
        });
    }
}
