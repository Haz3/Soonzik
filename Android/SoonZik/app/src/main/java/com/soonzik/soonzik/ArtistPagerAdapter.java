package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

/**
 * Created by kevin_000 on 12/06/2015.
 */
public class ArtistPagerAdapter extends FragmentStatePagerAdapter {
    CharSequence Titles[];
    int NumbOfTabs;
    int idUser;

    public ArtistPagerAdapter(FragmentManager fm, CharSequence mTitles[], int mNumbOfTabsumb, int miduser) {
        super(fm);

        this.Titles = mTitles;
        this.NumbOfTabs = mNumbOfTabsumb;
        this.idUser = miduser;
    }

    @Override
    public Fragment getItem(int position) {
        Bundle bundle = new Bundle();
        bundle.putInt("artist_id", this.idUser);

        switch (position) {
            case 0:
                ArtistDescriptionFragment artistDescriptionFragment = new ArtistDescriptionFragment();
                artistDescriptionFragment.setArguments(bundle);
                return artistDescriptionFragment;
            case 1:
                ArtistAlbumsFragment albumFragment = new ArtistAlbumsFragment();
                albumFragment.setArguments(bundle);
                return albumFragment;
            case 2:
                ArtistFollowersFragment artistFollowersFragment = new ArtistFollowersFragment();
                artistFollowersFragment.setArguments(bundle);
                return artistFollowersFragment;
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
