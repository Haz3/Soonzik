package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Text;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class UserProfileUpdateFragment extends Fragment {

    Button updateValidateButton;
    private String redirectClass = "com.soonzik.soonzik.UserProfileFragment";

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_userprofileupdate,
                container, false);

        try {
            ActiveRecord.show("User", ActiveRecord.currentUser.getId(), false, new ActiveRecord.OnJSONResponseCallback() {

                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject obj = (JSONObject) response;

                    User res = (User) ActiveRecord.jsonObjectData(obj, classT);

                    ((EditText) view.findViewById(R.id.emailUpdateInput)).setText(res.getEmail());
                    ((EditText) view.findViewById(R.id.lnameUpdateInput)).setText(res.getLname());
                    ((EditText) view.findViewById(R.id.fnameUpdateInput)).setText(res.getFname());
                    ((TextView) view.findViewById(R.id.usernameUpdateInput)).setText(res.getUsername());
                    ((EditText) view.findViewById(R.id.birthdayUpdateInput)).setText(res.getBirthday());
                    ((EditText) view.findViewById(R.id.descriptionUpdateInput)).setText(res.getDescription());
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        updateValidateButton = (Button) view.findViewById(R.id.updateValidateButton);
        updateValidateButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Map<String, String> params = new HashMap<String, String>();

                params.put("email", ((EditText) view.findViewById(R.id.emailUpdateInput)).getText().toString());
                params.put("lname", ((EditText) view.findViewById(R.id.lnameUpdateInput)).getText().toString());
                params.put("fname", ((EditText) view.findViewById(R.id.fnameUpdateInput)).getText().toString());
                params.put("birthday", ((EditText) view.findViewById(R.id.birthdayUpdateInput)).getText().toString());
                params.put("description", ((EditText) view.findViewById(R.id.descriptionUpdateInput)).getText().toString());

                /*Uri uri = Uri.parse("www.google.com/images/image.jpg");
                File f = new File("" + uri);

                ContentResolver cR = getActivity().getContentResolver();
                MimeTypeMap mime = MimeTypeMap.getSingleton();
                String type = cR.getType(uri);
                String filename = f.getName();*/


                try {
                    ActiveRecord.update("User", params, new ActiveRecord.OnJSONResponseCallback() {
                        @Override
                        public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {

                            FragmentTransaction tx = getActivity().getSupportFragmentManager().beginTransaction();
                            tx.replace(R.id.main, Fragment.instantiate(getActivity(), redirectClass));
                            tx.commit();

                            Toast t = Toast.makeText(getActivity(), "Your informations are update with success", Toast.LENGTH_LONG);
                            t.show();
                        }
                    });
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });

        return view;
    }
}
