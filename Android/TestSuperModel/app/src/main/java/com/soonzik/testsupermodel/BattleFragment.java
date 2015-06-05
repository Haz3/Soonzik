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
 * Created by kevin_000 on 13/05/2015.
 */
public class BattleFragment extends Fragment {

    TextView nameText;
    TextView idText;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        final View view = inflater.inflate(R.layout.fragment_battle,
                container, false);

        int id = this.getArguments().getInt("battle_id");

        try {
            ActiveRecord.show("Battle", id, false, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONObject data = (JSONObject) response;
                    Battle battle = (Battle) ActiveRecord.jsonObjectData(data, classT);

                    nameText = (TextView) getActivity().findViewById(R.id.battleName);
                    idText = (TextView) getActivity().findViewById(R.id.battleId);
                    User artist_one = battle.getArtistOne();
                    User artist_two = battle.getArtistTwo();

                    nameText.setText(artist_one.getUsername() + " / " + artist_two.getUsername());
                    idText.setText(Integer.toString(battle.getId()));
                }
            });
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return view;
    }

}
