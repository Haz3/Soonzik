package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

/**
 * Created by kevin_000 on 28/05/2015.
 */
public class SearchPagerAdapter extends FragmentStatePagerAdapter {

    CharSequence Titles[];
    int NumbOfTabs;
    String searchText;

    public SearchPagerAdapter(FragmentManager fm, CharSequence mTitles[], int mNumbOfTabsumb, String mSearchText) {
        super(fm);

        this.Titles = mTitles;
        this.NumbOfTabs = mNumbOfTabsumb;
        this.searchText = mSearchText;
    }

    @Override
    public Fragment getItem(int position) {
        Bundle bundle = new Bundle();
        bundle.putString("searchtext", searchText);

        switch (position) {
            case 0:
                SearchAllFragment resultFragment = new SearchAllFragment();
                resultFragment.setArguments(bundle);
                return resultFragment;
            case 1:
                SearchMusicsFragment musicFragment = new SearchMusicsFragment();
                musicFragment.setArguments(bundle);
                return musicFragment;
            case 2:
                SearchPacksFragment packFragment = new SearchPacksFragment();
                packFragment.setArguments(bundle);
                return packFragment;
            case 3:
                SearchUserFragment userFragment = new SearchUserFragment();
                userFragment.setArguments(bundle);
                return userFragment;
            case 4:
                SearchArtistFragment artistFragment = new SearchArtistFragment();
                artistFragment.setArguments(bundle);
                return artistFragment;
            default:
                return null;
        }

    }

    @Override
    public int getItemPosition(Object object) {
        return POSITION_NONE;
    }

    @Override
    public int getCount() {
        return NumbOfTabs;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return Titles[position];
    }

    public void setSearchText(String mSearchText) {
        searchText = mSearchText;
    }

}
