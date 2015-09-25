package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class MyContentFragment extends Fragment {

    MyContentPagerAdapter adapter;
    ViewPager pager;
    SlidingTabLayout tabs;
    CharSequence Titles[] = {"Music","Album", "Pack"};
    int NumbOfTabs = 3;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_mycontent,
                container, false);

        adapter = new MyContentPagerAdapter(getActivity().getSupportFragmentManager(), Titles, NumbOfTabs);

        pager = (ViewPager) view.findViewById(R.id.mycontentPager);
        pager.setAdapter(adapter);

        tabs = (SlidingTabLayout) view.findViewById(R.id.tabs);
        tabs.setDistributeEvenly(true);

        tabs.setCustomTabColorizer(new SlidingTabLayout.TabColorizer() {
            @Override
            public int getIndicatorColor(int position) {
                return getResources().getColor(R.color.tabs_explorer);
            }
        });

        tabs.setViewPager(pager);

        return view;
    }

}
