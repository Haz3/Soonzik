package com.soonzik.soonzik;

import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.concurrent.TimeUnit;

/**
 * Created by kevin_000 on 05/06/2015.
 */
public class Player extends Fragment {

    private Button b1,b2,b3,b4;
    private ImageView iv;
    private MediaPlayer mediaPlayer;
    private double startTime = 0;
    private double finalTime = 0;
    private Handler myHandler = new Handler();;
    private int forwardTime = 5000;
    private int backwardTime = 5000;
    private SeekBar seekbar;
    private TextView tx1,tx2,tx3;

    public static int oneTimeOnly = 0;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        final View v = inflater.inflate(R.layout.fragment_player, container, false);

        b1 = (Button) v.findViewById(R.id.button);
        b2 = (Button) v.findViewById(R.id.button2);
        b3=(Button)v.findViewById(R.id.button3);
        b4=(Button)v.findViewById(R.id.button4);
        iv=(ImageView)v.findViewById(R.id.imageView);

        tx1=(TextView)v.findViewById(R.id.textView2);
        tx2=(TextView)v.findViewById(R.id.textView3);
        tx3=(TextView)v.findViewById(R.id.textView4);
        tx3.setText("Song.mp3");

        int id = getArguments().getInt("music_id");

        mediaPlayer = new MediaPlayer();
        mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);

        seekbar = (SeekBar) v.findViewById(R.id.seekBar);
        seekbar.setClickable(false);
        b2.setEnabled(false);

        if (ActiveRecord.currentUser != null) {
            Music.getSecureUrl(1, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    try {
                        mediaPlayer.setDataSource((String) response);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            });
        }
        else {
            try {
                mediaPlayer.setDataSource(ActiveRecord.serverLink + "musics/get/1");
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        try {
            mediaPlayer.prepare();
        } catch (IOException e) {
            e.printStackTrace();
        }

        b3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getActivity(), "Playing sound", Toast.LENGTH_SHORT).show();

                mediaPlayer.start();

                finalTime = mediaPlayer.getDuration();
                startTime = mediaPlayer.getCurrentPosition();

                if (oneTimeOnly == 0) {
                    seekbar.setMax((int) finalTime);
                    oneTimeOnly = 1;
                }
                tx2.setText(String.format("%d min, %d sec",
                                TimeUnit.MILLISECONDS.toMinutes((long) finalTime),
                                TimeUnit.MILLISECONDS.toSeconds((long) finalTime) -
                                        TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long) finalTime)))
                );

                tx1.setText(String.format("%d min, %d sec",
                                TimeUnit.MILLISECONDS.toMinutes((long) startTime),
                                TimeUnit.MILLISECONDS.toSeconds((long) startTime) -
                                        TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long) startTime)))
                );

                seekbar.setProgress((int) startTime);
                myHandler.postDelayed(UpdateSongTime, 100);
                b2.setEnabled(true);
                b3.setEnabled(false);
            }
        });

        b2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Toast.makeText(getActivity(), "Pausing sound", Toast.LENGTH_SHORT).show();
                mediaPlayer.pause();
                b2.setEnabled(false);
                b3.setEnabled(true);
            }
        });

        b1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int temp = (int) startTime;

                if ((temp + forwardTime) <= finalTime) {
                    startTime = startTime + forwardTime;
                    mediaPlayer.seekTo((int) startTime);
                    Toast.makeText(getActivity(), "You have Jumped forward 5 seconds", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(getActivity(), "Cannot jump forward 5 seconds", Toast.LENGTH_SHORT).show();
                }
            }
        });

        b4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                int temp = (int) startTime;

                if ((temp - backwardTime) > 0) {
                    startTime = startTime - backwardTime;
                    mediaPlayer.seekTo((int) startTime);
                    Toast.makeText(getActivity(), "You have Jumped backward 5 seconds", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(getActivity(), "Cannot jump backward 5 seconds", Toast.LENGTH_SHORT).show();
                }
            }
        });

        /*Music.get(id, new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                Uri r = (Uri) response;

                mediaPlayer = MediaPlayer.create(getActivity(), r);
                seekbar = (SeekBar) v.findViewById(R.id.seekBar);
                seekbar.setClickable(false);
                b2.setEnabled(false);

                b3.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Toast.makeText(getActivity(), "Playing sound", Toast.LENGTH_SHORT).show();
                        mediaPlayer.start();

                        finalTime = mediaPlayer.getDuration();
                        startTime = mediaPlayer.getCurrentPosition();

                        if (oneTimeOnly == 0) {
                            seekbar.setMax((int) finalTime);
                            oneTimeOnly = 1;
                        }
                        tx2.setText(String.format("%d min, %d sec",
                                        TimeUnit.MILLISECONDS.toMinutes((long) finalTime),
                                        TimeUnit.MILLISECONDS.toSeconds((long) finalTime) -
                                                TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long) finalTime)))
                        );

                        tx1.setText(String.format("%d min, %d sec",
                                        TimeUnit.MILLISECONDS.toMinutes((long) startTime),
                                        TimeUnit.MILLISECONDS.toSeconds((long) startTime) -
                                                TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.toMinutes((long) startTime)))
                        );

                        seekbar.setProgress((int) startTime);
                        myHandler.postDelayed(UpdateSongTime, 100);
                        b2.setEnabled(true);
                        b3.setEnabled(false);
                    }
                });

                b2.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Toast.makeText(getActivity(), "Pausing sound", Toast.LENGTH_SHORT).show();
                        mediaPlayer.pause();
                        b2.setEnabled(false);
                        b3.setEnabled(true);
                    }
                });

                b1.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        int temp = (int) startTime;

                        if ((temp + forwardTime) <= finalTime) {
                            startTime = startTime + forwardTime;
                            mediaPlayer.seekTo((int) startTime);
                            Toast.makeText(getActivity(), "You have Jumped forward 5 seconds", Toast.LENGTH_SHORT).show();
                        } else {
                            Toast.makeText(getActivity(), "Cannot jump forward 5 seconds", Toast.LENGTH_SHORT).show();
                        }
                    }
                });

                b4.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        int temp = (int) startTime;

                        if ((temp - backwardTime) > 0) {
                            startTime = startTime - backwardTime;
                            mediaPlayer.seekTo((int) startTime);
                            Toast.makeText(getActivity(), "You have Jumped backward 5 seconds", Toast.LENGTH_SHORT).show();
                        } else {
                            Toast.makeText(getActivity(), "Cannot jump backward 5 seconds", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
        });*/



        return v;
    }

    private Runnable UpdateSongTime = new Runnable() {
        public void run() {
            startTime = mediaPlayer.getCurrentPosition();
            tx1.setText(String.format("%d min, %d sec",

                            TimeUnit.MILLISECONDS.toMinutes((long) startTime),
                            TimeUnit.MILLISECONDS.toSeconds((long) startTime) -
                                    TimeUnit.MINUTES.toSeconds(TimeUnit.MILLISECONDS.
                                            toMinutes((long) startTime)))
            );
            seekbar.setProgress((int)startTime);
            myHandler.postDelayed(this, 100);
        }
    };

}
