package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

/**
 * Created by kevin_000 on 12/06/2015.
 */
public class PackPagerAdapter extends FragmentStatePagerAdapter {
    CharSequence Titles[];
    int NumbOfTabs;
    int idPack;

    public PackPagerAdapter(FragmentManager fm, CharSequence mTitles[], int mNumbOfTabsumb, int midpack) {
        super(fm);

        this.Titles = mTitles;
        this.NumbOfTabs = mNumbOfTabsumb;
        this.idPack = midpack;
    }

    @Override
    public Fragment getItem(int position) {
        Bundle bundle = new Bundle();
        bundle.putInt("pack_id", this.idPack);

        switch (position) {
            case 0:
                PackAlbumsFragment albumFragment = new PackAlbumsFragment();
                albumFragment.setArguments(bundle);
                return albumFragment;
            case 1:
                PackArtistsFragment artistFragment = new PackArtistsFragment();
                artistFragment.setArguments(bundle);
                return artistFragment;
            case 2:
                PackAssociationFragment musicFragment = new PackAssociationFragment();
                musicFragment.setArguments(bundle);
                return musicFragment;
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
