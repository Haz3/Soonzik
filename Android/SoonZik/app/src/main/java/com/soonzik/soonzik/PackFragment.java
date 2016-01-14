package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class PackFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.PackPurchaseFragment";

    PackPagerAdapter adapter;
    ViewPager pager;
    SlidingTabLayout tabs;
    CharSequence Titles[]={"Albums","Artists", "Association"};
    int NumbOfTabs = 3;

    TextView nameText;
    TextView textViewArtist;
    TextView textViewDescription;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_pack,
                container, false);

        final int id = this.getArguments().getInt("pack_id");

        try {
            ActiveRecord.show("Pack", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    final Pack pack = (Pack) ActiveRecord.jsonObjectData(data, classT);

                    nameText = (TextView) getActivity().findViewById(R.id.packName);
                    nameText.setText(pack.getTitle());

                    textViewArtist = (TextView) getActivity().findViewById(R.id.packartists);
                    ArrayList<Album> alb = pack.getAlbums();

                    String arts = "";
                    ArrayList<String> artistes = new ArrayList<String>();

                    int nbalb = 0;
                    if (alb != null) {
                        nbalb = alb.size();
                        String tmp = "";
                        for (Album album : alb) {
                            tmp = album.getUser().getUsername();
                            if (!artistes.contains(tmp))
                                artistes.add(tmp);
                        }
                        int i = 1;
                        for (String name : artistes) {
                            arts += name;
                            if (i < artistes.size())
                                arts += " / ";
                            i++;
                        }
                    }
                    textViewArtist.setText(arts);

                    textViewDescription = (TextView) getActivity().findViewById(R.id.packdescription);

                    for (Description desc : pack.getDescriptions()) {
                        if (desc.getLanguage().equals("FR")) {
                            textViewDescription.setText(desc.getDescription());
                        }
                    }

                    TextView minimalPrice = (TextView) view.findViewById(R.id.minimalprice);
                    minimalPrice.setText(Double.toString(Math.round( pack.getMinimal_price() * 100.0 ) / 100.0) + "$");

                    TextView averagePrice = (TextView) view.findViewById(R.id.averageprice);
                    averagePrice.setText(Double.toString(Math.round( pack.getAveragePrice() * 100.0 ) / 100.0) + "$");

                    Button purchasePack = (Button) view.findViewById(R.id.buypackbutton);

                    ArrayList<Pack> packs = ActiveRecord.currentUser.getContent().getPacks();
                    for (Pack p : packs) {
                        if (p.getId() == id) {
                            purchasePack.setVisibility(View.GONE);
                            view.findViewById(R.id.textView).setVisibility(View.GONE);
                            view.findViewById(R.id.minimalprice).setVisibility(View.GONE);
                            view.findViewById(R.id.textView5).setVisibility(View.GONE);
                            view.findViewById(R.id.averageprice).setVisibility(View.GONE);
                        }
                    }

                    purchasePack.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            Bundle bundle = new Bundle();
                            bundle.putInt("pack_id", pack.getId());
                            Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                            frg.setArguments(bundle);

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
                            tx.addToBackStack(null);
                            tx.commit();
                        }
                    });

                    adapter = new PackPagerAdapter(getActivity().getSupportFragmentManager(), Titles, NumbOfTabs, pack.getId());

                    pager = (ViewPager) view.findViewById(R.id.packPager);
                    pager.setAdapter(adapter);

                    tabs = (SlidingTabLayout) view.findViewById(R.id.tabs);
                    tabs.setDistributeEvenly(true);

                    tabs.setCustomTabColorizer(new SlidingTabLayout.TabColorizer() {
                        @Override
                        public int getIndicatorColor(int position) {
                            return getResources().getColor(R.color.tabs_pack);
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
