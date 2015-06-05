package com.soonzik.testsupermodel;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class NewsFragment extends Fragment {

    TextView newsTitle;
    TextView newsContent;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_news,
                container, false);

        int id = this.getArguments().getInt("news_id");

        try {
            ActiveRecord.show("News", id, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    News news = (News) ActiveRecord.jsonObjectData(data, classT);

                    newsTitle = (TextView) view.findViewById(R.id.news_title);
                    newsContent = (TextView) view.findViewById(R.id.news_content);

                    ArrayList<Newstext> texts = news.getNewstext();
                    for (Newstext text : texts) {
                        if (text.getLanguage().equals("FR")) {
                            newsTitle.setText(text.getTitle());
                            newsContent.setText(text.getContent());
                        }
                    }

                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return view;
    }
}
