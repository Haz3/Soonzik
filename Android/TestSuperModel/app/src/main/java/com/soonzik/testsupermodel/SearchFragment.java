package com.soonzik.testsupermodel;

import android.app.ActionBar;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Created by kevin_000 on 28/05/2015.
 */
public class SearchFragment extends Fragment {

    SearchPagerAdapter adapter;
    ViewPager pager;
    SlidingTabLayout tabs;

    EditText searchfield;

    CharSequence Titles[]={"All","Music", "Pack", "User"};
    int NumbOfTabs = 4;
    String searchText;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_search,
                container, false);

        searchfield = (EditText) view.findViewById(R.id.searchfield);

        adapter = new SearchPagerAdapter(getActivity().getSupportFragmentManager(), Titles, NumbOfTabs, searchText);

        searchfield.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_NULL
                        && event.getAction() == KeyEvent.ACTION_DOWN) {
                    searchText = searchfield.getText().toString();
                    adapter.setSearchText(searchText);//match this behavior to your 'Send' (or Confirm) button
                    adapter.notifyDataSetChanged();
                }
                return true;
            }
        });

        pager = (ViewPager) view.findViewById(R.id.searchPager);
        pager.setAdapter(adapter);

        tabs = (SlidingTabLayout) view.findViewById(R.id.tabs);
        tabs.setDistributeEvenly(true);

        tabs.setCustomTabColorizer(new SlidingTabLayout.TabColorizer() {
            @Override
            public int getIndicatorColor(int position) {
                return getResources().getColor(R.color.tabs_search);
            }
        });



        /*searchfield.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                searchText = searchfield.getText().toString();
                adapter.setSearchText(searchText);

                int pos = pager.getCurrentItem();

                Log.v("POSITION", Integer.toString(pos));
            }
        });*/

        tabs.setViewPager(pager);

        return view;
    }

}
