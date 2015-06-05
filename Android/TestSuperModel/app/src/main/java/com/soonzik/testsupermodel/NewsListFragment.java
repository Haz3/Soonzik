package com.soonzik.testsupermodel;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import org.json.JSONArray;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 05/05/2015.
 */
public class NewsListFragment extends Fragment {

    private String redirectClass = "com.soonzik.testsupermodel.NewsFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.listfragment_news,
                container, false);

        try {
            ActiveRecord.index("News", new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> news = ActiveRecord.jsonArrayData(data, classT);
                    NewsAdapter adapter = new NewsAdapter(getActivity(), news);

                    ListView lv = (ListView) getActivity().findViewById(R.id.newslistview);
                    lv.setAdapter(adapter);

                    lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {

                            Bundle bundle = new Bundle();
                            bundle.putInt("news_id", ((News) news.get(position)).getId());
                            Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                            frg.setArguments(bundle);

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
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
