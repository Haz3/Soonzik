package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;

import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 12/06/2015.
 */
public class PackAssociationFragment extends Fragment {

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        final View v;
        int id = this.getArguments().getInt("pack_id");

        v = inflater.inflate(R.layout.fragment_pack_association,container,false);

        try {
            ActiveRecord.show("Pack", id, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    Pack pack = (Pack) ActiveRecord.jsonObjectData(data, classT);

                    TextView descriptionAssociation = (TextView) v.findViewById(R.id.descriptionAssociation);
                    descriptionAssociation.setText(pack.getUser().getDescription());
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return v;
    }
}
