package com.soonzik.soonzik;

import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

import com.loopj.android.http.RequestParams;

import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;

/**
 * Created by Kevin on 2016-01-12.
 */
public class MusicDownloadFragment extends Fragment {

    private ProgressBar pBar;
    private String music_title;
    private int music_id;

    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_musicdownload,
                container, false);

        music_id = getArguments().getInt("music_id");
        music_title = getArguments().getString("music_title");

        pBar = (ProgressBar) view.findViewById(R.id.downloadprogressbar);
        pBar.setMax(100);

        RequestParams params = new RequestParams();
        params.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
        //params.put("download", Boolean.toString(true));

        params.put("secureKey", ActiveRecord.secureKey);

        new DownloadFileFromURL().execute(ActiveRecord.serverLink + "musics/get/" + Integer.toString(music_id) + "?" + params.toString());

        return view;
    }

    class DownloadFileFromURL extends AsyncTask<String, String, String> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        /**
         * Downloading file in background thread
         * */
        @Override
        protected String doInBackground(String... f_url) {
            int count;
            try {
                URL url = new URL(f_url[0]);
                URLConnection connection = url.openConnection();
                connection.connect();
                // getting file length
                int lenghtOfFile = connection.getContentLength();

                // input stream to read file - with 8k buffer
                InputStream input = new BufferedInputStream(url.openStream(), 8192);

                // Output stream to write file
                OutputStream output = new FileOutputStream(Environment.getExternalStorageDirectory().getPath() + "/" + music_title  + ".mp3");

                byte data[] = new byte[1024];

                long total = 0;
                //int i = 0;
                while ((count = input.read(data)) != -1) {
                    total += count;
                    // publishing the progress....
                    // After this onProgressUpdate will be called
                    publishProgress(""+(int)((total*100)/lenghtOfFile));

                    // writing data to file
                    output.write(data, 0, count);
                }
                Log.v("TOTAL", Long.toString(total));

                // flushing output
                output.flush();

                // closing streams
                output.close();
                input.close();

            } catch (Exception e) {
                Log.e("Error: ", e.getMessage());
            }

            return null;
        }

        @Override
        protected void onProgressUpdate(String... progress) {
            // setting progress percentage

            pBar.setProgress(Integer.parseInt(progress[0]));
        }

        @Override
        protected void onPostExecute(String file_url) {

            Fragment frg = Fragment.instantiate(getActivity(), "com.soonzik.soonzik.MyContentFragment");

            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
            tx.replace(R.id.main, frg);
            tx.commit();
        }

    }
}
