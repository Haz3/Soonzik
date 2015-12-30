package com.soonzik.soonzik;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.SeekBar;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.paypal.android.sdk.payments.PayPalConfiguration;
import com.paypal.android.sdk.payments.PayPalPayment;
import com.paypal.android.sdk.payments.PayPalService;
import com.paypal.android.sdk.payments.PaymentActivity;
import com.paypal.android.sdk.payments.PaymentConfirmation;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Kevin on 2015-09-09.
 */
public class PackPurchaseFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.PackFragment";
    private static PayPalConfiguration config;
    private float finalamount;
    private Pack pack;
    private SeekBar seekBarArtist;
    private SeekBar seekBarCharity;
    private SeekBar seekBarDeveloper;
    private int gift_id = -1;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_pack_purchase,
                container, false);

        int id = this.getArguments().getInt("pack_id");


        config = new PayPalConfiguration()

                // Start with mock environment.  When ready, switch to sandbox (ENVIRONMENT_SANDBOX)
                // or live (ENVIRONMENT_PRODUCTION)
                .environment(PayPalConfiguration.ENVIRONMENT_SANDBOX)
                .clientId("AfCwBQSyxx6Ys2fnbB_1AmmuINiAPaGlGtk38vTZTCbcevPBIU0Ptt4TgvjNznxkLbSi9fdiaJxG8-u-");

        ArrayList<User> friends = ActiveRecord.currentUser.getFriends();
        List<String> friends_name = new ArrayList<>();
        List<Integer> friends_id = new ArrayList<>();
        friends_name.add("");
        friends_id.add(-1);
        for (User f : friends) {
            friends_name.add(f.getUsername());
            friends_id.add(f.getId());
        }

        final Spinner spinner = (Spinner) view.findViewById(R.id.friends_spinner);
        final ArrayAdapter<String> adapter = new ArrayAdapter<String>(getActivity(),
                android.R.layout.simple_spinner_item, friends_name);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int pos, long l) {
                gift_id = ActiveRecord.currentUser.getFriends().get(pos).getId();
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        try {
            ActiveRecord.show("Pack", id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;

                    pack = (Pack) ActiveRecord.jsonObjectData(data, classT);

                    TextView packName = (TextView) getActivity().findViewById(R.id.packname);
                    packName.setText(pack.getTitle());

                    TextView artistnames = (TextView) getActivity().findViewById(R.id.artistnames);
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
                    artistnames.setText(arts);

                    TextView nbAlbums = (TextView) view.findViewById(R.id.nbalbums);
                    nbAlbums.setText((alb != null ? Integer.toString(alb.size()) : "0"));

                    final EditText editTextAmount = (EditText) view.findViewById(R.id.edittextamount);
                    editTextAmount.setText(Double.toString(pack.getAveragePrice() + 0.01));
                    final Double[] amount = {Double.parseDouble(editTextAmount.getText().toString())};

                    seekBarArtist = (SeekBar) view.findViewById(R.id.seekbarartist);
                    seekBarCharity = (SeekBar) view.findViewById(R.id.seekbarcharity);
                    seekBarDeveloper = (SeekBar) view.findViewById(R.id.seekbardeveloper);

                    final TextView valueArtist = (TextView) view.findViewById(R.id.valueforartist);
                    final TextView valueCharity = (TextView) view.findViewById(R.id.valueforcharity);
                    final TextView valueDeveloper = (TextView) view.findViewById(R.id.valuefordeveloper);

                    valueArtist.setText(Integer.toString(seekBarArtist.getProgress()) + "% ~" + String.format("%.2f", seekBarArtist.getProgress() * amount[0] / 100) + "$");
                    valueCharity.setText(Integer.toString(seekBarCharity.getProgress()) + "% ~" + String.format("%.2f", seekBarCharity.getProgress() * amount[0] / 100) + "$");
                    valueDeveloper.setText(Integer.toString(seekBarDeveloper.getProgress()) + "% ~" + String.format("%.2f", seekBarDeveloper.getProgress() * amount[0] / 100) + "$");

                    editTextAmount.addTextChangedListener(new TextWatcher() {
                        @Override
                        public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

                        }

                        @Override
                        public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                            amount[0] = Double.parseDouble(editTextAmount.getText().toString());

                            double artistAmount = Double.parseDouble(String.format("%.2f", seekBarArtist.getProgress() * amount[0] / 100));
                            double charityAmount = Double.parseDouble(String.format("%.2f", seekBarCharity.getProgress() * amount[0] / 100));
                            double developerAmount = Double.parseDouble(String.format("%.2f", seekBarDeveloper.getProgress() * amount[0] / 100));

                            double totalValue = artistAmount + charityAmount + developerAmount;

                            if (totalValue < amount[0]) {
                                if (artistAmount > 0) {
                                    artistAmount += amount[0] - totalValue;
                                } else if (charityAmount > 0) {
                                    charityAmount += amount[0] - totalValue;
                                } else {
                                    developerAmount += amount[0] - totalValue;
                                }
                            } else if (totalValue > amount[0]) {
                                if (artistAmount > 0) {
                                    artistAmount -= (totalValue - amount[0]);
                                } else if (charityAmount > 0) {
                                    charityAmount -= (totalValue - amount[0]);
                                } else {
                                    developerAmount -= (totalValue - amount[0]);
                                }
                            }

                            valueArtist.setText(Integer.toString(seekBarArtist.getProgress()) + "% ~" + String.format("%.2f", artistAmount) + "$");
                            valueCharity.setText(Integer.toString(seekBarCharity.getProgress()) + "% ~" + String.format("%.2f", charityAmount) + "$");
                            valueDeveloper.setText(Integer.toString(seekBarDeveloper.getProgress()) + "% ~" + String.format("%.2f", developerAmount) + "$");
                        }

                        @Override
                        public void afterTextChanged(Editable editable) {

                        }
                    });


                    seekBarArtist.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
                        int progress = seekBarArtist.getProgress();
                        boolean fromUser = false;
                        int diff = 0;


                        @Override
                        public void onProgressChanged(SeekBar seekBar, int progresValue, boolean fromUs) {
                            if (fromUs) {
                                diff += progresValue - progress;
                                valueArtist.setText(Integer.toString(seekBarArtist.getProgress()) + "% ~" + String.format("%.2f", seekBarArtist.getProgress() * amount[0] / 100) + "$");
                            } else {
                                diff = 0;
                            }
                            progress = progresValue;
                            fromUser = fromUs;
                        }

                        @Override
                        public void onStartTrackingTouch(SeekBar seekBar) {
                            diff = 0;
                        }

                        @Override
                        public void onStopTrackingTouch(SeekBar seekBar) {

                            if (fromUser) {
                                int progressCharity = seekBarCharity.getProgress();
                                int progressDeveloper = seekBarDeveloper.getProgress();

                                if (progress == 100) {
                                    seekBarDeveloper.setProgress(0);
                                    seekBarCharity.setProgress(0);
                                } else if (progressCharity == 0 && diff > 0 && progressDeveloper > 0) {
                                    seekBarDeveloper.setProgress(progressDeveloper - diff);
                                } else if (progressDeveloper == 0 && diff > 0 && progressCharity > 0) {
                                    seekBarCharity.setProgress(progressCharity - diff);
                                } else if (progressDeveloper - (diff / 2) < 0) {
                                    diff = diff + progressDeveloper;
                                    seekBarDeveloper.setProgress(0);
                                    seekBarCharity.setProgress(progressCharity - diff);
                                } else if (progressCharity - (diff / 2) < 0) {
                                    diff = diff + progressCharity;
                                    seekBarCharity.setProgress(0);
                                    seekBarDeveloper.setProgress(progressDeveloper - diff);
                                } else {
                                    seekBarCharity.setProgress(progressCharity - (diff / 2));
                                    seekBarDeveloper.setProgress(progressDeveloper - (diff / 2));
                                }
                                fromUser = false;
                            }
                            diff = 0;

                            int totalPercent = seekBarArtist.getProgress() + seekBarCharity.getProgress() + seekBarDeveloper.getProgress();

                            if (totalPercent < 100) {
                                if (seekBarCharity.getProgress() > 0) {
                                    seekBarCharity.setProgress(seekBarCharity.getProgress() + 100 - totalPercent);
                                } else if (seekBarDeveloper.getProgress() > 0) {
                                    seekBarDeveloper.setProgress(seekBarDeveloper.getProgress() + 100 - totalPercent);
                                } else {
                                    seekBarArtist.setProgress(seekBarArtist.getProgress() + 100 - totalPercent);
                                }
                            } else if (totalPercent > 100) {
                                if (seekBarCharity.getProgress() > 0) {
                                    seekBarCharity.setProgress(seekBarCharity.getProgress() - (totalPercent - 100));
                                } else if (seekBarDeveloper.getProgress() > 0) {
                                    seekBarDeveloper.setProgress(seekBarDeveloper.getProgress() - (totalPercent - 100));
                                } else {
                                    seekBarArtist.setProgress(seekBarArtist.getProgress() - (totalPercent - 100));
                                }
                            }

                            double artistAmount = Double.parseDouble(String.format("%.2f", seekBarArtist.getProgress() * amount[0] / 100));
                            double charityAmount = Double.parseDouble(String.format("%.2f", seekBarCharity.getProgress() * amount[0] / 100));
                            double developerAmount = Double.parseDouble(String.format("%.2f", seekBarDeveloper.getProgress() * amount[0] / 100));

                            double totalValue = artistAmount + charityAmount + developerAmount;

                            if (totalValue < amount[0]) {
                                if (charityAmount > 0) {
                                    charityAmount += amount[0] - totalValue;
                                } else if (developerAmount > 0) {
                                    developerAmount += amount[0] - totalValue;
                                } else {
                                    artistAmount += amount[0] - totalValue;
                                }
                            } else if (totalValue > amount[0]) {
                                if (charityAmount > 0) {
                                    charityAmount -= (totalValue - amount[0]);
                                } else if (developerAmount > 0) {
                                    developerAmount -= (totalValue - amount[0]);
                                } else {
                                    artistAmount -= (totalValue - amount[0]);
                                }
                            }

                            valueArtist.setText(Integer.toString(seekBarArtist.getProgress()) + "% ~" + String.format("%.2f", artistAmount) + "$");
                            valueCharity.setText(Integer.toString(seekBarCharity.getProgress()) + "% ~" + String.format("%.2f", charityAmount) + "$");
                            valueDeveloper.setText(Integer.toString(seekBarDeveloper.getProgress()) + "% ~" + String.format("%.2f", developerAmount) + "$");
                        }
                    });

                    seekBarCharity.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
                        int progress = seekBarCharity.getProgress();
                        boolean fromUser = false;
                        int diff = 0;

                        @Override
                        public void onProgressChanged(SeekBar seekBar, int progresValue, boolean fromUs) {
                            if (fromUs) {
                                diff += progresValue - progress;
                                valueCharity.setText(Integer.toString(seekBarCharity.getProgress()) + "% ~" + String.format("%.2f", seekBarCharity.getProgress() * amount[0] / 100) + "$");
                            } else {
                                diff = 0;
                            }
                            progress = progresValue;
                            fromUser = fromUs;
                        }

                        @Override
                        public void onStartTrackingTouch(SeekBar seekBar) {
                            diff = 0;
                        }

                        @Override
                        public void onStopTrackingTouch(SeekBar seekBar) {
                            if (fromUser) {
                                int progressArtist = seekBarArtist.getProgress();
                                int progressDeveloper = seekBarDeveloper.getProgress();

                                if (progress == 100) {
                                    seekBarArtist.setProgress(0);
                                    seekBarDeveloper.setProgress(0);
                                } else if (progressArtist == 0 && diff > 0 && progressDeveloper > 0) {
                                    seekBarDeveloper.setProgress(progressDeveloper - diff);
                                } else if (progressDeveloper == 0 && diff > 0 && progressArtist > 0) {
                                    seekBarArtist.setProgress(progressArtist - diff);
                                } else if (progressDeveloper - (diff / 2) < 0) {
                                    diff -= progressDeveloper;
                                    seekBarDeveloper.setProgress(0);
                                    seekBarArtist.setProgress(progressArtist - diff);
                                } else if (progressArtist - (diff / 2) < 0) {
                                    diff -= progressArtist;
                                    seekBarArtist.setProgress(0);
                                    seekBarDeveloper.setProgress(progressDeveloper - diff);
                                } else {
                                    seekBarArtist.setProgress(progressArtist - (diff / 2));
                                    seekBarDeveloper.setProgress(progressDeveloper - (diff / 2));
                                }
                                fromUser = false;
                            }
                            diff = 0;

                            int totalPercent = seekBarArtist.getProgress() + seekBarCharity.getProgress() + seekBarDeveloper.getProgress();

                            if (totalPercent < 100) {
                                if (seekBarArtist.getProgress() > 0) {
                                    seekBarArtist.setProgress(seekBarArtist.getProgress() + 100 - totalPercent);
                                } else if (seekBarDeveloper.getProgress() > 0) {
                                    seekBarDeveloper.setProgress(seekBarDeveloper.getProgress() + 100 - totalPercent);
                                } else {
                                    seekBarCharity.setProgress(seekBarCharity.getProgress() + 100 - totalPercent);
                                }
                            } else if (totalPercent > 100) {
                                if (seekBarArtist.getProgress() > 0) {
                                    seekBarArtist.setProgress(seekBarArtist.getProgress() - (totalPercent - 100));
                                } else if (seekBarDeveloper.getProgress() > 0) {
                                    seekBarDeveloper.setProgress(seekBarDeveloper.getProgress() - (totalPercent - 100));
                                } else {
                                    seekBarCharity.setProgress(seekBarCharity.getProgress() - (totalPercent - 100));
                                }
                            }

                            double artistAmount = Double.parseDouble(String.format("%.2f", seekBarArtist.getProgress() * amount[0] / 100));
                            double charityAmount = Double.parseDouble(String.format("%.2f", seekBarCharity.getProgress() * amount[0] / 100));
                            double developerAmount = Double.parseDouble(String.format("%.2f", seekBarDeveloper.getProgress() * amount[0] / 100));

                            double totalValue = artistAmount + charityAmount + developerAmount;

                            if (totalValue < amount[0]) {
                                if (artistAmount > 0) {
                                    artistAmount += amount[0] - totalValue;
                                } else if (developerAmount > 0) {
                                    developerAmount += amount[0] - totalValue;
                                } else {
                                    charityAmount += amount[0] - totalValue;
                                }
                            } else if (totalValue > amount[0]) {
                                if (artistAmount > 0) {
                                    artistAmount -= (totalValue - amount[0]);
                                } else if (developerAmount > 0) {
                                    developerAmount -= (totalValue - amount[0]);
                                } else {
                                    charityAmount -= (totalValue - amount[0]);
                                }
                            }

                            valueArtist.setText(Integer.toString(seekBarArtist.getProgress()) + "% ~" + String.format("%.2f", artistAmount) + "$");
                            valueCharity.setText(Integer.toString(seekBarCharity.getProgress()) + "% ~" + String.format("%.2f", charityAmount) + "$");
                            valueDeveloper.setText(Integer.toString(seekBarDeveloper.getProgress()) + "% ~" + String.format("%.2f", developerAmount) + "$");
                        }
                    });

                    seekBarDeveloper.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
                        int progress = seekBarDeveloper.getProgress();
                        boolean fromUser = false;
                        int diff = 0;

                        @Override
                        public void onProgressChanged(SeekBar seekBar, int progresValue, boolean fromUs) {
                            if (fromUs) {
                                diff += progresValue - progress;
                                valueDeveloper.setText(Integer.toString(seekBarDeveloper.getProgress()) + "% ~" + String.format("%.2f", seekBarDeveloper.getProgress() * amount[0] / 100) + "$");
                            } else {
                                diff = 0;
                            }
                            progress = progresValue;
                            fromUser = fromUs;
                        }

                        @Override
                        public void onStartTrackingTouch(SeekBar seekBar) {
                            diff = 0;
                        }

                        @Override
                        public void onStopTrackingTouch(SeekBar seekBar) {
                            if (fromUser) {
                                int progressArtist = seekBarArtist.getProgress();
                                int progressCharity = seekBarCharity.getProgress();

                                if (progress == 100) {
                                    seekBarArtist.setProgress(0);
                                    seekBarCharity.setProgress(0);
                                } else if (progressArtist == 0 && diff > 0 && progressCharity > 0) {
                                    seekBarCharity.setProgress(progressCharity - diff);
                                } else if (progressCharity == 0 && diff > 0 && progressArtist > 0) {
                                    seekBarArtist.setProgress(progressArtist - diff);
                                } else if (progressCharity - (diff / 2) < 0) {
                                    diff = diff + progressCharity;
                                    seekBarCharity.setProgress(0);
                                    seekBarArtist.setProgress(progressArtist - diff);
                                } else if (progressArtist - (diff / 2) < 0) {
                                    diff = diff + progressArtist;
                                    seekBarArtist.setProgress(0);
                                    seekBarCharity.setProgress(progressCharity - diff);
                                } else {
                                    seekBarArtist.setProgress(progressArtist - (diff / 2));
                                    seekBarCharity.setProgress(progressCharity - (diff / 2));
                                }
                                fromUser = false;
                            }
                            diff = 0;

                            int totalPercent = seekBarArtist.getProgress() + seekBarCharity.getProgress() + seekBarDeveloper.getProgress();

                            if (totalPercent < 100) {
                                if (seekBarArtist.getProgress() > 0) {
                                    seekBarArtist.setProgress(seekBarArtist.getProgress() + 100 - totalPercent);
                                } else if (seekBarCharity.getProgress() > 0) {
                                    seekBarCharity.setProgress(seekBarCharity.getProgress() + 100 - totalPercent);
                                } else {
                                    seekBarDeveloper.setProgress(seekBarDeveloper.getProgress() + 100 - totalPercent);
                                }
                            } else if (totalPercent > 100) {
                                if (seekBarArtist.getProgress() > 0) {
                                    seekBarArtist.setProgress(seekBarArtist.getProgress() - (totalPercent - 100));
                                } else if (seekBarCharity.getProgress() > 0) {
                                    seekBarCharity.setProgress(seekBarCharity.getProgress() - (totalPercent - 100));
                                } else {
                                    seekBarDeveloper.setProgress(seekBarDeveloper.getProgress() - (totalPercent - 100));
                                }
                            }

                            double artistAmount = Double.parseDouble(String.format("%.2f", seekBarArtist.getProgress() * amount[0] / 100));
                            double charityAmount = Double.parseDouble(String.format("%.2f", seekBarCharity.getProgress() * amount[0] / 100));
                            double developerAmount = Double.parseDouble(String.format("%.2f", seekBarDeveloper.getProgress() * amount[0] / 100));

                            double totalValue = artistAmount + charityAmount + developerAmount;

                            if (totalValue < amount[0]) {
                                if (artistAmount > 0) {
                                    artistAmount += amount[0] - totalValue;
                                } else if (charityAmount > 0) {
                                    charityAmount += amount[0] - totalValue;
                                } else {
                                    developerAmount += amount[0] - totalValue;
                                }
                            } else if (totalValue > amount[0]) {
                                if (artistAmount > 0) {
                                    artistAmount -= (totalValue - amount[0]);
                                } else if (charityAmount > 0) {
                                    charityAmount -= (totalValue - amount[0]);
                                } else {
                                    developerAmount -= (totalValue - amount[0]);
                                }
                            }

                            valueArtist.setText(Integer.toString(seekBarArtist.getProgress()) + "% ~" + String.format("%.2f", artistAmount) + "$");
                            valueCharity.setText(Integer.toString(seekBarCharity.getProgress()) + "% ~" + String.format("%.2f", charityAmount) + "$");
                            valueDeveloper.setText(Integer.toString(seekBarDeveloper.getProgress()) + "% ~" + String.format("%.2f", developerAmount) + "$");
                        }
                    });

                    Button purchasePack = (Button) view.findViewById(R.id.purchasebutton);
                    purchasePack.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            finalamount = Float.parseFloat(editTextAmount.getText().toString());

                            onBuyPressed(view);
                        }
                    });

                }
            });


        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return view;
    }

    public void onBuyPressed(View pressed) {

        // PAYMENT_INTENT_SALE will cause the payment to complete immediately.
        // Change PAYMENT_INTENT_SALE to
        //   - PAYMENT_INTENT_AUTHORIZE to only authorize payment and capture funds later.
        //   - PAYMENT_INTENT_ORDER to create a payment for authorization and capture
        //     later via calls from your server.

        PayPalPayment payment = new PayPalPayment(new BigDecimal(finalamount), "EUR", pack.getTitle(),
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

                    Purchase.buyPack(pack.getId(), finalamount, seekBarArtist.getProgress(), seekBarCharity.getProgress(), seekBarDeveloper.getProgress(), paypal, gift_id, new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                            JSONObject obj = (JSONObject) response;
                            Toast.makeText(getActivity(), "Purchase OK", Toast.LENGTH_SHORT).show();

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
