package com.soonzik.soonzik;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.paypal.android.sdk.payments.PayPalConfiguration;
import com.paypal.android.sdk.payments.PayPalPayment;
import com.paypal.android.sdk.payments.PayPalService;
import com.paypal.android.sdk.payments.PaymentActivity;
import com.paypal.android.sdk.payments.PaymentConfirmation;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by kevin_000 on 03/08/2015.
 */
public class CartFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.NewsListFragment";
    private ArrayList<Object> carts = null;
    private static PayPalConfiguration config;
    private float totalPrice;

    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_cart,
                container, false);


        config = new PayPalConfiguration()

                // Start with mock environment.  When ready, switch to sandbox (ENVIRONMENT_SANDBOX)
                // or live (ENVIRONMENT_PRODUCTION)
                .environment(PayPalConfiguration.ENVIRONMENT_NO_NETWORK)
                .clientId("AfCwBQSyxx6Ys2fnbB_1AmmuINiAPaGlGtk38vTZTCbcevPBIU0Ptt4TgvjNznxkLbSi9fdiaJxG8-u-");

        try {
            Cart.myCart(new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> items = ActiveRecord.jsonArrayData(data, classT);
                    carts = new ArrayList<Object>(items);

                    int nbArticle = 0;
                    totalPrice = 0;

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
                    totalValue.setText(Float.toString(totalPrice) + "$");

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
                    onBuyPressed(view);
                }
            }
        });

        return view;
    }

    public void onBuyPressed(View pressed) {

        // PAYMENT_INTENT_SALE will cause the payment to complete immediately.
        // Change PAYMENT_INTENT_SALE to
        //   - PAYMENT_INTENT_AUTHORIZE to only authorize payment and capture funds later.
        //   - PAYMENT_INTENT_ORDER to create a payment for authorization and capture
        //     later via calls from your server.

        PayPalPayment payment = new PayPalPayment(new BigDecimal(totalPrice), "EUR", "Music on SoonZik",
                PayPalPayment.PAYMENT_INTENT_SALE);

        Intent intent = new Intent(getActivity(), PaymentActivity.class);

        // send the same configuration for restart resiliency
        intent.putExtra(PayPalService.EXTRA_PAYPAL_CONFIGURATION, config);

        intent.putExtra(PaymentActivity.EXTRA_PAYMENT, payment);

        startActivityForResult(intent, 0);
    }

    @Override
    public void onActivityResult (int requestCode, int resultCode, Intent data) {
        if (resultCode == Activity.RESULT_OK) {
            PaymentConfirmation confirm = data.getParcelableExtra(PaymentActivity.EXTRA_RESULT_CONFIRMATION);
            if (confirm != null) {
                try {
                    Log.i("paymentExample", confirm.toJSONObject().toString(4));

                    JSONObject paypalJSON = confirm.toJSONObject();

                    HashMap<String, String> paypal = new HashMap<String, String>();

                    Log.v("PAYPALID", paypalJSON.getJSONObject("response").get("id").toString());

                    paypal.put("payment_id", paypalJSON.getJSONObject("response").get("id").toString());
                    paypal.put("payment_method", "");
                    paypal.put("status", paypalJSON.getJSONObject("response").get("state").toString());
                    paypal.put("payer_email", "");
                    paypal.put("payer_first_name", "");
                    paypal.put("payer_last_name", "");
                    paypal.put("payer_id", "");
                    paypal.put("payer_phone", "");
                    paypal.put("payer_country_code", "");
                    paypal.put("payer_street", "");
                    paypal.put("payer_city", "");
                    paypal.put("payer_postal_code", "");
                    paypal.put("payer_country_code", "");
                    paypal.put("payer_recipient_name", "");

                    Purchase.buyCart(paypal, new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                            JSONObject obj = (JSONObject) response;
                            Toast.makeText(getActivity(), "Purchase OK", Toast.LENGTH_SHORT).show();

                            Bundle bundle = new Bundle();
                            Fragment frg = Fragment.instantiate(getActivity(), redirectClass);
                            frg.setArguments(bundle);

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, frg);
                            tx.addToBackStack(null);
                            tx.commit();
                        }
                    });

                } catch (JSONException e) {
                    Log.e("paymentExample", "an extremely unlikely failure occurred: ", e);
                }
            }
        }
        else if (resultCode == Activity.RESULT_CANCELED) {
            Log.i("paymentExample", "The user canceled.");
        }
        else if (resultCode == PaymentActivity.RESULT_EXTRAS_INVALID) {
            Log.i("paymentExample", "An invalid Payment or PayPalConfiguration was submitted. Please see the docs.");
        }
    }
}
