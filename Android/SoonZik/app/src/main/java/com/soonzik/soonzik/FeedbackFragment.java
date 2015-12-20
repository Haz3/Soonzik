package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Kevin on 2015-10-31.
 */

public class FeedbackFragment extends Fragment {

    private String redirectClass = "com.soonzik.soonzik.NewsListFragment";
    private String issueCode;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_feedback,
                container, false);


        final EditText emailFeedback = (EditText) view.findViewById(R.id.feedback_email);

        if (ActiveRecord.currentUser != null) {
            emailFeedback.setText(ActiveRecord.currentUser.getEmail());
        }

        final Spinner spinner = (Spinner) view.findViewById(R.id.feedback_spinner);
        final String[] issueCodes = getResources().getStringArray(R.array.feedback_code);
        final ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(getActivity(),
                R.array.feedback_array, android.R.layout.simple_spinner_item);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int pos, long l) {
                issueCode = issueCodes[pos];
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

        final EditText subject = (EditText) view.findViewById(R.id.feedbacksubject);
        final EditText feedbackContent = (EditText) view.findViewById(R.id.feedback);


        Button feedbackSend = (Button) view.findViewById(R.id.feedbacksend);
        feedbackSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String email = emailFeedback.getText().toString();
                String sub = subject.getText().toString();
                String content = feedbackContent.getText().toString();

                Log.v("FEEDBACK", "email = " + email);
                Log.v("FEEDBACK", "type_object = " + issueCode);
                Log.v("FEEDBACK", "object = " + sub);
                Log.v("FEEDBACK", "text = " + content);

                Map<String, String> data = new HashMap<String, String>();
                data.put("email", email);
                data.put("type_object", issueCode);
                data.put("object", sub);
                data.put("text", content);

                ActiveRecord.save("Feedback", data, new ActiveRecord.OnJSONResponseCallback() {
                    @Override
                    public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException, JSONException {
                        JSONObject obj = (JSONObject) response;

                        Toast.makeText(getActivity(), "Feedback send", Toast.LENGTH_SHORT).show();

                        Bundle bundle = new Bundle();
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

        return view;
    }

}

