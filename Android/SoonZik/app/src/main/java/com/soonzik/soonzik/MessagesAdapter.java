package com.soonzik.soonzik;

import android.content.Context;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by kevin_000 on 24/06/2015.
 */
public class MessagesAdapter extends ArrayAdapter<Object> {
    private final Context context;
    private final List<Object> values;

    public MessagesAdapter(Context context, List<Object> objects) {
        super(context, R.layout.row_messages, objects);
        this.context = context;
        this.values = objects;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View rowView = inflater.inflate(R.layout.row_messages, parent, false);
        Message ms = (Message) values.get(position);

        TextView textViewMsg = (TextView) rowView.findViewById(R.id.textmsg);
        textViewMsg.setText(ms.getMsg());

        if (ms.getUser_id() == ActiveRecord.currentUser.getId()) {
            textViewMsg.setBackgroundResource(R.drawable.bubble_green);
            textViewMsg.setGravity(Gravity.END);
        }
        else {
            textViewMsg.setBackgroundResource(R.drawable.bubble_yellow);
            textViewMsg.setGravity(Gravity.START);
        }

        return rowView;
    }
}