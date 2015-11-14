package com.soonzik.soonzik;

import android.support.v4.app.FragmentManager;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentStatePagerAdapter;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class ExplorerPagerAdapter extends FragmentStatePagerAdapter {

    CharSequence Titles[];
    int NumbOfTabs;

    public ExplorerPagerAdapter(FragmentManager fm, CharSequence mTitles[], int mNumbOfTabsumb) {
        super(fm);

        this.Titles = mTitles;
        this.NumbOfTabs = mNumbOfTabsumb;
    }

    @Override
    public Fragment getItem(int position) {

        switch (position) {
            case 0:
                ExplorerInfluencesFragment influenceFragment = new ExplorerInfluencesFragment();
                return influenceFragment;
            case 1:
                ExplorerMusicsFragment musicFragment = new ExplorerMusicsFragment();
                return musicFragment;
            case 2:
                ExplorerPacksFragment packFragment = new ExplorerPacksFragment();
                return packFragment;
            default:
                return null;
        }

    }

    @Override
    public int getCount() {
        return NumbOfTabs;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return Titles[position];
    }
}
