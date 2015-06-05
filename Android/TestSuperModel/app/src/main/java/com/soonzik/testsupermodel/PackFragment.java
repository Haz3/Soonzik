package com.soonzik.testsupermodel;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;

/**
 * Created by kevin_000 on 26/05/2015.
 */
public class PackFragment extends Fragment {

    TextView nameText;
    TextView idText;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View view = inflater.inflate(R.layout.fragment_pack,
                container, false);

        int id = this.getArguments().getInt("pack_id");

        try {
            ActiveRecord.show("Pack", id, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    Pack pack = (Pack) ActiveRecord.jsonObjectData(data, classT);

                    nameText = (TextView) getActivity().findViewById(R.id.packName);
                    idText = (TextView) getActivity().findViewById(R.id.packId);

                    nameText.setText(pack.getTitle());
                    idText.setText(Integer.toString(pack.getId()));
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return view;
    }
}
