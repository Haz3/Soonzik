package com.soonzik.soonzik;

import android.app.DialogFragment;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.ActionBarActivity;

import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends ActionBarActivity
        implements PlaylistCreateDialogFragment.NoticeDialogListener{

    private DrawerLayout drawer;
    private ListView navList;
    private ActionBarDrawerToggle drawerToggle;

    private CharSequence titleSection;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final String[] names = getResources().getStringArray(R.array.nav_names);
        final String[] classes = getResources().getStringArray(R.array.nav_classes);
        final String[] icons = getResources().getStringArray(R.array.nav_icons);

        MenuAdapter adapter = new MenuAdapter(this, names, icons);

        titleSection = getTitle();

        drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        navList = (ListView) findViewById(R.id.drawer);
        navList.setAdapter(adapter);
        navList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                FragmentTransaction tx = getSupportFragmentManager().beginTransaction();
                tx.replace(R.id.main, Fragment.instantiate(MainActivity.this, classes[position]));
                tx.commit();

                titleSection = names[position];
                drawer.closeDrawer(navList);
            }
        });

        drawerToggle = new ActionBarDrawerToggle(this,
                drawer,
                R.string.open_menu,
                R.string.close_menu) {

            @Override
            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);
                getSupportActionBar().setTitle(titleSection);
                ActivityCompat.invalidateOptionsMenu(MainActivity.this);
            }

            @Override
            public void onDrawerOpened(View view) {
                super.onDrawerOpened(view);
                getSupportActionBar().setTitle(getTitle());
                ActivityCompat.invalidateOptionsMenu(MainActivity.this);
            }
        };

        drawer.setDrawerListener(drawerToggle);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

        FragmentTransaction tx = getSupportFragmentManager().beginTransaction();
        tx.replace(R.id.main, Fragment.instantiate(MainActivity.this, classes[0]));
        tx.commit();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (drawerToggle.onOptionsItemSelected(item)) {
            return true;
        }

        switch(item.getItemId())
        {
            case R.id.action_search:
                showSearchFragment();
                Toast.makeText(this, "Search", Toast.LENGTH_SHORT).show();
                break;
            case R.id.action_create_playlist:
                showNoticeDialog();
                break;
            default:
                return super.onOptionsItemSelected(item);
        }

        return true;
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {

        boolean menuOuvert = drawer.isDrawerOpen(navList);

        if(menuOuvert) {
            menu.findItem(R.id.action_search).setVisible(false);
        }
        else {
            menu.findItem(R.id.action_search).setVisible(true);
        }
        return super.onPrepareOptionsMenu(menu);
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        drawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        drawerToggle.onConfigurationChanged(newConfig);
    }

    @Override
    public void onBackPressed() {
        if (getFragmentManager().getBackStackEntryCount() > 0 ){
            getFragmentManager().popBackStack();
        } else {
            super.onBackPressed();
        }
    }

    public void showSearchFragment() {
        FragmentTransaction tx = getSupportFragmentManager().beginTransaction();
        tx.replace(R.id.main, Fragment.instantiate(MainActivity.this, "com.soonzik.soonzik.SearchFragment"));
        tx.commit();
    }

    public void showNoticeDialog() {
        // Create an instance of the dialog fragment and show it
        DialogFragment newFragment = new PlaylistCreateDialogFragment();
        newFragment.show(getFragmentManager(), "com.soonzik.soonzik.PlaylistCreateDialogFragment");
    }

    @Override
    public void onDialogPositiveClick(DialogFragment dialog) {
        // User touched the dialog's positive button

        FragmentTransaction tx = getSupportFragmentManager().beginTransaction();
        tx.replace(R.id.main, Fragment.instantiate(MainActivity.this, "com.soonzik.soonzik.PlaylistsListFragment"));
        tx.commit();
    }

    @Override
    public void onDialogNegativeClick(DialogFragment dialog) {

    }

}
