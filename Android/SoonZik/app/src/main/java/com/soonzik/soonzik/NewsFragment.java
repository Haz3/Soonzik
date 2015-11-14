package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class NewsFragment extends Fragment {

    private TextView newsTitle;
    private TextView newsContent;
    private ImageButton newsLiked;
    private Button commentNews;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_news,
                container, false);

        int id = this.getArguments().getInt("news_id");

        try {
            ActiveRecord.show("News", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    final News news = (News) ActiveRecord.jsonObjectData(data, classT);

                    newsTitle = (TextView) view.findViewById(R.id.news_title);
                    newsContent = (TextView) view.findViewById(R.id.news_content);

                    newsTitle.setText(news.getTitle());
                    newsContent.setText(news.getContent());

                    newsLiked = (ImageButton) view.findViewById(R.id.liked_news);

                    if (news.isHasLiked()) {
                        newsLiked.setImageResource(R.drawable.like);
                    } else {
                        newsLiked.setImageResource(R.drawable.unlike);
                    }

                    newsLiked.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            if (news.isHasLiked()) {
                                User.unlikeContent("News", news.getId(), new ActiveRecord.OnJSONResponseCallback() {
                                    @Override
                                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                                        newsLiked.setImageResource(R.drawable.unlike);
                                        news.setHasLiked(!news.isHasLiked());
                                        news.setLikes(news.getLikes() - 1);
                                    }
                                });
                            } else {
                                User.likeContent("News", news.getId(), new ActiveRecord.OnJSONResponseCallback() {
                                    @Override
                                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                                        newsLiked.setImageResource(R.drawable.like);
                                        news.setHasLiked(!news.isHasLiked());
                                        news.setLikes(news.getLikes() + 1);
                                    }
                                });
                            }
                        }
                    });

                    commentNews = (Button) view.findViewById(R.id.comment_news);
                    commentNews.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            Bundle commentBundle = new Bundle();
                            commentBundle.putString("class", "News");
                            commentBundle.putInt("to_comment_id", news.getId());
                            Fragment frgComment = Fragment.instantiate(getActivity(), "com.soonzik.soonzik.CommentaryListFragment");
                            frgComment.setArguments(commentBundle);

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frgComment);
                            tx.addToBackStack(null);
                            tx.commit();
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
