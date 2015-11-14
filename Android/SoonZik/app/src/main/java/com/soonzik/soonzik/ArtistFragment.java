package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import org.json.JSONArray;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 12/06/2015.
 */
public class ArtistFragment extends Fragment {
    ArtistPagerAdapter adapter;
    ViewPager pager;
    SlidingTabLayout tabs;
    CharSequence Titles[]={"Info","Albums", "Followers"};
    int NumbOfTabs = 3;
    boolean follow = false;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_artist,
                container, false);

        int id = this.getArguments().getInt("artist_id");

        try {
            ActiveRecord.show("User", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    final User user = (User) ActiveRecord.jsonObjectData(data, classT);

                    ImageView imageViewPicture = (ImageView) view.findViewById(R.id.artistpicture);
                    imageViewPicture.setImageResource(R.drawable.ic_profile);

                    TextView textViewName = (TextView) view.findViewById(R.id.artistname);
                    textViewName.setText(user.getUsername());

                    TextView textViewCountry = (TextView) view.findViewById(R.id.countryartist);
                    textViewCountry.setText("France");

                    final TextView textViewFollowers = (TextView) view.findViewById(R.id.nbfollowers);

                    user.getFollowers(user.getId(), new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                            JSONArray data = (JSONArray) response;

                            final ArrayList<Object> friends = ActiveRecord.jsonArrayData(data, classT);

                            int nbFollowers = friends.size();
                            textViewFollowers.setText(Integer.toString(nbFollowers));
                        }
                    });

                    final Button followbutton = (Button) view.findViewById(R.id.followbutton);

                    followbutton.setText("Follow");
                    if (ActiveRecord.currentUser != null) {
                        followbutton.setVisibility(View.VISIBLE);
                        for (User us : ActiveRecord.currentUser.getFollows()) {
                            if (us.getId() == user.getId()) {
                                follow = true;
                                followbutton.setText("Unfollow");
                                break;
                            }
                        }
                    }

                    followbutton.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            if (!follow) {
                                User.follow(user.getId(), new ActiveRecord.OnJSONResponseCallback() {
                                    @Override
                                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                                        JSONArray data = (JSONArray) response;

                                        ArrayList<Object> arrayData = ActiveRecord.jsonArrayData(data, classT);
                                        ArrayList<User> follows = new ArrayList<User>();

                                        for (Object obj : arrayData) {
                                            follows.add((User) obj);
                                        }

                                        ActiveRecord.currentUser.setFollows(follows);
                                        followbutton.setText("Unfollow");
                                        follow = !follow;
                                    }
                                });
                            }
                            else {
                                User.unfollow(user.getId(), new ActiveRecord.OnJSONResponseCallback() {
                                    @Override
                                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                                        JSONArray data = (JSONArray) response;

                                        ArrayList<Object> arrayData = ActiveRecord.jsonArrayData(data, classT);
                                        ArrayList<User> follows = new ArrayList<User>();

                                        for (Object obj : arrayData) {
                                            follows.add((User) obj);
                                        }

                                        ActiveRecord.currentUser.setFollows(follows);
                                        followbutton.setText("Follow");
                                        follow = !follow;
                                    }
                                });
                            }
                        }
                    });



                    adapter = new ArtistPagerAdapter(getActivity().getSupportFragmentManager(), Titles, NumbOfTabs, user.getId());

                    pager = (ViewPager) view.findViewById(R.id.artistPager);
                    pager.setAdapter(adapter);

                    tabs = (SlidingTabLayout) view.findViewById(R.id.tabs);
                    tabs.setDistributeEvenly(true);

                    tabs.setCustomTabColorizer(new SlidingTabLayout.TabColorizer() {
                        @Override
                        public int getIndicatorColor(int position) {
                            return getResources().getColor(R.color.tabs_artist);
                        }
                    });

                    tabs.setViewPager(pager);
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return view;
    }
}
