package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by kevin_000 on 03/08/2015.
 */
public class CartFragment extends Fragment {

    private ArrayList<Object> carts = null;

    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_cart,
                container, false);

        try {
            Cart.myCart(new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> items = ActiveRecord.jsonArrayData(data, classT);
                    carts = new ArrayList<Object>(items);

                    int nbArticle = 0;
                    double totalPrice = 0;

                    for (Object ct : items) {
                        if (((Cart) ct).getMusics().size() > 0) {
                            for (Music mc : ((Cart) ct).getMusics()) {
                                totalPrice += mc.getPrice();
                                nbArticle++;
                            }
                        } else if (((Cart) ct).getAlbums().size() > 0) {
                            for (Album am : ((Cart) ct).getAlbums()) {
                                totalPrice += am.getPrice();
                                nbArticle++;
                            }
                        }
                    }
                    TextView nbItems = (TextView) view.findViewById(R.id.nbobject);
                    nbItems.setText(Integer.toString(nbArticle));

                    TextView totalValue = (TextView) view.findViewById(R.id.totalvalue);
                    totalValue.setText(Double.toString(totalPrice) + "$");

                    CartsAdapter cartsAdapter = new CartsAdapter(getActivity(), items);
                    ListView lv = (ListView) getActivity().findViewById(R.id.cartslistview);
                    lv.setAdapter(cartsAdapter);

                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        Button purchase = (Button) view.findViewById(R.id.purchasebutton);
        purchase.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (carts != null) {
                    Purchase.buyCart(new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                            JSONObject obj = (JSONObject) response;
                            Toast.makeText(getActivity(), "Purchase OK", Toast.LENGTH_SHORT).show();
                        }
                    });

                }
            }
        });

        return view;
    }
}
