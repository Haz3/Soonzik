package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;

/**
 * Created by Kevin on 2015-09-09.
 */
public class PackPurchaseFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.PackFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_pack_purchase,
                container, false);

        int id = this.getArguments().getInt("pack_id");

        try {
            ActiveRecord.show("Pack", id, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;

                    final Pack pack = (Pack) ActiveRecord.jsonObjectData(data, classT);

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

                    final SeekBar seekBarArtist = (SeekBar) view.findViewById(R.id.seekbarartist);
                    final SeekBar seekBarCharity = (SeekBar) view.findViewById(R.id.seekbarcharity);
                    final SeekBar seekBarDeveloper = (SeekBar) view.findViewById(R.id.seekbardeveloper);

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
                                Log.v("TOTAL VALUE < amount", Double.toString(totalValue));
                                if (artistAmount > 0) {
                                    artistAmount += amount[0] - totalValue;
                                } else if (charityAmount > 0) {
                                    charityAmount += amount[0] - totalValue;
                                } else {
                                    developerAmount += amount[0] - totalValue;
                                }
                            } else if (totalValue > amount[0]) {
                                Log.v("TOTAL VALUE > amount", Double.toString(totalValue));
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

                            Log.v("DIFF ARTIST 1", Integer.toString(diff));
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
                                    Log.v("CASE", "1");
                                    seekBarDeveloper.setProgress(0);
                                    seekBarCharity.setProgress(0);
                                } else if (progressCharity == 0 && diff > 0 && progressDeveloper > 0) {
                                    Log.v("CASE", "2");
                                    Log.v("Dev", Integer.toString(progressDeveloper));
                                    Log.v("diff", Integer.toString(diff));
                                    seekBarDeveloper.setProgress(progressDeveloper - diff);
                                } else if (progressDeveloper == 0 && diff > 0 && progressCharity > 0) {
                                    Log.v("CASE", "3");
                                    seekBarCharity.setProgress(progressCharity - diff);
                                } else if (progressDeveloper - (diff / 2) < 0) {
                                    Log.v("CASE", "4");
                                    diff = diff + progressDeveloper;
                                    seekBarDeveloper.setProgress(0);
                                    seekBarCharity.setProgress(progressCharity - diff);
                                } else if (progressCharity - (diff / 2) < 0) {
                                    Log.v("CASE", "5");
                                    diff = diff + progressCharity;
                                    seekBarCharity.setProgress(0);
                                    seekBarDeveloper.setProgress(progressDeveloper - diff);
                                } else {
                                    Log.v("CASE", "6");
                                    seekBarCharity.setProgress(progressCharity - (diff / 2));
                                    seekBarDeveloper.setProgress(progressDeveloper - (diff / 2));
                                }
                                fromUser = false;
                            }
                            diff = 0;

                            int totalPercent = seekBarArtist.getProgress() + seekBarCharity.getProgress() + seekBarDeveloper.getProgress();

                            if (totalPercent < 100) {
                                Log.v("TOTAL PERCENT < 100", Integer.toString(totalPercent));
                                if (seekBarCharity.getProgress() > 0) {
                                    seekBarCharity.setProgress(seekBarCharity.getProgress() + 100 - totalPercent);
                                } else if (seekBarDeveloper.getProgress() > 0) {
                                    seekBarDeveloper.setProgress(seekBarDeveloper.getProgress() + 100 - totalPercent);
                                } else {
                                    seekBarArtist.setProgress(seekBarArtist.getProgress() + 100 - totalPercent);
                                }
                            } else if (totalPercent > 100) {
                                Log.v("TOTAL PERCENT > 100", Integer.toString(totalPercent));
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
                                Log.v("TOTAL VALUE < amount", Double.toString(totalValue));
                                if (charityAmount > 0) {
                                    charityAmount += amount[0] - totalValue;
                                } else if (developerAmount > 0) {
                                    developerAmount += amount[0] - totalValue;
                                } else {
                                    artistAmount += amount[0] - totalValue;
                                }
                            } else if (totalValue > amount[0]) {
                                Log.v("TOTAL VALUE > amount", Double.toString(totalValue));
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
                            Log.v("DIFF CHARITY", Integer.toString(diff));
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
                                    Log.v("CASE", "1");
                                    seekBarArtist.setProgress(0);
                                    seekBarDeveloper.setProgress(0);
                                } else if (progressArtist == 0 && diff > 0 && progressDeveloper > 0) {
                                    Log.v("CASE", "2");
                                    seekBarDeveloper.setProgress(progressDeveloper - diff);
                                } else if (progressDeveloper == 0 && diff > 0 && progressArtist > 0) {
                                    Log.v("CASE", "3");
                                    seekBarArtist.setProgress(progressArtist - diff);
                                } else if (progressDeveloper - (diff / 2) < 0) {
                                    Log.v("CASE", "4");
                                    diff -= progressDeveloper;
                                    seekBarDeveloper.setProgress(0);
                                    seekBarArtist.setProgress(progressArtist - diff);
                                } else if (progressArtist - (diff / 2) < 0) {
                                    Log.v("CASE", "5");
                                    diff -= progressArtist;
                                    seekBarArtist.setProgress(0);
                                    seekBarDeveloper.setProgress(progressDeveloper - diff);
                                } else {
                                    Log.v("CASE", "6");
                                    seekBarArtist.setProgress(progressArtist - (diff / 2));
                                    seekBarDeveloper.setProgress(progressDeveloper - (diff / 2));
                                }
                                fromUser = false;
                            }
                            diff = 0;

                            int totalPercent = seekBarArtist.getProgress() + seekBarCharity.getProgress() + seekBarDeveloper.getProgress();

                            if (totalPercent < 100) {
                                Log.v("TOTAL PERCENT < 100", Integer.toString(totalPercent));
                                if (seekBarArtist.getProgress() > 0) {
                                    seekBarArtist.setProgress(seekBarArtist.getProgress() + 100 - totalPercent);
                                } else if (seekBarDeveloper.getProgress() > 0) {
                                    seekBarDeveloper.setProgress(seekBarDeveloper.getProgress() + 100 - totalPercent);
                                } else {
                                    seekBarCharity.setProgress(seekBarCharity.getProgress() + 100 - totalPercent);
                                }
                            } else if (totalPercent > 100) {
                                Log.v("TOTAL PERCENT > 100", Integer.toString(totalPercent));

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
                                Log.v("TOTAL VALUE < amount", Double.toString(totalValue));
                                if (artistAmount > 0) {
                                    artistAmount += amount[0] - totalValue;
                                } else if (developerAmount > 0) {
                                    developerAmount += amount[0] - totalValue;
                                } else {
                                    charityAmount += amount[0] - totalValue;
                                }
                            } else if (totalValue > amount[0]) {
                                Log.v("TOTAL VALUE > amount", Double.toString(totalValue));
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
                            Log.v("DIFF DEVELOPER", Integer.toString(diff));
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
                                    Log.v("CASE", "1");
                                    seekBarArtist.setProgress(0);
                                    seekBarCharity.setProgress(0);
                                } else if (progressArtist == 0 && diff > 0 && progressCharity > 0) {
                                    Log.v("CASE", "2");
                                    seekBarCharity.setProgress(progressCharity - diff);
                                } else if (progressCharity == 0 && diff > 0 && progressArtist > 0) {
                                    Log.v("CASE", "3");
                                    seekBarArtist.setProgress(progressArtist - diff);
                                } else if (progressCharity - (diff / 2) < 0) {
                                    Log.v("CASE", "4");
                                    diff = diff + progressCharity;
                                    seekBarCharity.setProgress(0);
                                    seekBarArtist.setProgress(progressArtist - diff);
                                } else if (progressArtist - (diff / 2) < 0) {
                                    Log.v("CASE", "5");
                                    diff = diff + progressArtist;
                                    seekBarArtist.setProgress(0);
                                    seekBarCharity.setProgress(progressCharity - diff);
                                } else {
                                    Log.v("CASE", "6");
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
                                Log.v("TOTAL VALUE < amount", Double.toString(totalValue));
                                if (artistAmount > 0) {
                                    artistAmount += amount[0] - totalValue;
                                } else if (charityAmount > 0) {
                                    charityAmount += amount[0] - totalValue;
                                } else {
                                    developerAmount += amount[0] - totalValue;
                                }
                            } else if (totalValue > amount[0]) {
                                Log.v("TOTAL VALUE > amount", Double.toString(totalValue));
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
                            float finalamount = Float.parseFloat(editTextAmount.getText().toString());

                            Purchase.buyPack(pack.getId(), finalamount, seekBarArtist.getProgress(), seekBarCharity.getProgress(), seekBarDeveloper.getProgress(), new ActiveRecord.OnJSONResponseCallback() {
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
