package com.soonzik.soonzik;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import com.loopj.android.http.RequestParams;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import br.net.bmobile.websocketrails.WebSocketRailsChannel;
import br.net.bmobile.websocketrails.WebSocketRailsDataCallback;
import br.net.bmobile.websocketrails.WebSocketRailsDispatcher;

/**
 * Created by kevin_000 on 24/06/2015.
 */
public class MessageListFragment extends Fragment {

    private WebSocketRailsDispatcher dispatcher;
    private int toWho;
    private MessagesAdapter messagesAdapter;
    private ListView lv;
    private User friend;

    private class InfoConnection {
        String user_id;
        StringBuffer secureKey;

        public String getUser_id() {
            return user_id;
        }

        public StringBuffer getSecureKey() {
            return secureKey;
        }

        public void setUser_id(String user_id) {
            this.user_id = user_id;
        }

        public void setSecureKey(StringBuffer secureKey) {
            this.secureKey = secureKey;
        }
    }

    private class SendMessage {
        String user_id;
        StringBuffer secureKey;
        String messageValue;
        String toWho;

        public String getUser_id() {
            return user_id;
        }

        public void setUser_id(String user_id) {
            this.user_id = user_id;
        }

        public StringBuffer getSecureKey() {
            return secureKey;
        }

        public void setSecureKey(StringBuffer secureKey) {
            this.secureKey = secureKey;
        }

        public String getMessageValue() {
            return messageValue;
        }

        public void setMessageValue(String messageValue) {
            this.messageValue = messageValue;
        }

        public String getToWho() {
            return toWho;
        }

        public void setToWho(String toWho) {
            this.toWho = toWho;
        }

        @Override
        public String toString() {
            String str = "";

            str += "user_id = " + user_id;
            str += " : secureKey = " + secureKey;
            str += " : messageValue = " + messageValue;
            str += " : towho = " + toWho;

            return str;
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        final View v;

        /*Map<String, String> info = new HashMap<>();
        info.put("user_id", "4");
        info.put("dest_id", "6");
        info.put("msg", msg);

        ActiveRecord.save("Message", info, true, new ActiveRecord.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                Log.v("MSG", "AJOUTe");
            }
        });

        view = inflater.inflate(R.layout.fragment_userunlogged,
                container, false);*/

        if (ActiveRecord.currentUser != null) {
            v = inflater.inflate(R.layout.listfragment_messages,
                    container, false);

            int id = this.getArguments().getInt("user_id");
            toWho = id;

            ArrayList<User> friends = ActiveRecord.currentUser.getFriends();
            for (User f : friends) {
                if (f.getId() == toWho) {
                    friend = f;
                    break;
                }
            }

            Message.conversation(id, new ActiveRecord.OnJSONResponseCallback() {
                @Override
                public void onJSONResponse(boolean success, Object response, Class<?> classT) throws InvocationTargetException, NoSuchMethodException, java.lang.InstantiationException, IllegalAccessException {
                    JSONArray data = (JSONArray) response;

                    final ArrayList<Object> messages = ActiveRecord.jsonArrayData(data, classT);

                    messagesAdapter = new MessagesAdapter(getActivity(), messages);
                    lv = (ListView) getActivity().findViewById(R.id.messageslistview);
                    lv.setTranscriptMode(ListView.TRANSCRIPT_MODE_ALWAYS_SCROLL);
                    lv.setAdapter(messagesAdapter);
                }
            });

            try {
                dispatcher = new WebSocketRailsDispatcher( new URL("http://soonzikapi.herokuapp.com/websocket"));
                dispatcher.connect();
                triggerInitConnection();
                bindSocket();

                Button sendMsg = (Button) v.findViewById(R.id.sendmessage);
                sendMsg.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(final View view) {
                        String msg = ((EditText) v.findViewById(R.id.edittextmessage)).getText().toString();
                        triggerSendMessage(msg);
                        ((EditText) v.findViewById(R.id.edittextmessage)).setText("");
                    }
                });
            }
            catch (MalformedURLException e) {
                Log.v("WEBSOCKET", "T PAS CO AHAH");
                e.printStackTrace();
            }

        }
        else {
            v = inflater.inflate(R.layout.fragment_userunlogged,
                    container, false);
        }

        return v;
    }

    private void bindSocket() {
        dispatcher.bind("onlineFriends", new WebSocketRailsDataCallback() {
            @Override
            public void onDataAvailable(Object data) {
                // Do what you want with the data received.
                Log.v("WEBSOCKET", "onlineFriends " + data.toString());
            }
        });

        dispatcher.bind("newMsg", new WebSocketRailsDataCallback() {
            @Override
            public void onDataAvailable(Object data) {
                // Do what you want with the data received.
                Log.v("WEBSOCKET", "newMsg" + data.toString());

                /*if (((LinkedHashMap<String, String>) data).get("from").equals(friend.getUsername())) {
                    scrollMyListViewToBottom(((LinkedHashMap<String, String>) data).get("message"), false);
                }*/


                try {
                    JSONObject obj = new JSONObject(data.toString());
                    if (obj.get("from").toString().equals(friend.getUsername())) {
                        scrollMyListViewToBottom(obj.get("message").toString(), false);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });

        dispatcher.bind("newOnlineFriends", new WebSocketRailsDataCallback() {
            @Override
            public void onDataAvailable(Object data) {
                // Do what you want with the data received.
                Log.v("WEBSOCKET", "newOnlineFriends" + data.toString());
            }
        });

        dispatcher.bind("newOfflineFriends", new WebSocketRailsDataCallback() {
            @Override
            public void onDataAvailable(Object data) {
                // Do what you want with the data received.
                Log.v("WEBSOCKET", "newOfflineFriends" + data.toString());
            }
        });

        dispatcher.bind("connection_closed", new WebSocketRailsDataCallback() {
            @Override
            public void onDataAvailable(Object data) {
                // Do what you want with the data received.
                Log.v("WEBSOCKET", "connection_closed" + data.toString());
                triggerInitConnection();
            }
        });
    }

    private void triggerInitConnection() {
        ActiveRecord.currentUser.getUserSecureKey(new RequestParams(), new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException, IOException {
                Log.v("INITCONNECTION", Integer.toString(ActiveRecord.currentUser.getId()));
                Log.v("INITCONNECTION", sendSecure(response.getString("key")).toString());

                InfoConnection infoConnection = new InfoConnection();

                infoConnection.setUser_id(Integer.toString(ActiveRecord.currentUser.getId()));
                infoConnection.setSecureKey(sendSecure(response.getString("key")));
                dispatcher.trigger("init_connection", infoConnection);

                Log.v("WEBSOCKET", "init_connection NORMALEMENT TU ES CONNECTE");
            }
        });
    }

    private void triggerWhoIsOnline() {
        ActiveRecord.currentUser.getUserSecureKey(new RequestParams(), new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException, IOException {
                JSONObject whoIsOnline = new JSONObject();
                whoIsOnline.put("user_id", Integer.toString(ActiveRecord.currentUser.getId()));
                whoIsOnline.put("secureKey", sendSecure(response.getString("key")));

                dispatcher.trigger("who_is_online", whoIsOnline);
                Log.v("WEBSOCKET", "who_is_online NORMALEMENT TU VAS RECEVOIR QUELQUE CHOSE");
            }
        });
    }

    private void triggerSendMessage(final String message) {
        ActiveRecord.currentUser.getUserSecureKey(new RequestParams(), new User.OnJSONResponseCallback() {
            @Override
            public void onJSONResponse(boolean success, JSONObject response, RequestParams params) throws JSONException, UnsupportedEncodingException, NoSuchAlgorithmException, IOException {
                SendMessage messageSend = new SendMessage();

                messageSend.setUser_id(Integer.toString(ActiveRecord.currentUser.getId()));
                messageSend.setSecureKey(sendSecure(response.getString("key")));
                messageSend.setMessageValue(message);
                messageSend.setToWho(Integer.toString(toWho));

                Log.v("WEBSOCKET", messageSend.toString());

                dispatcher.trigger("messages.send", messageSend);
                Log.v("WEBSOCKET", "messages.send NORMALEMENT TU VAS RECEVOIR QUELQUE CHOSE");

                /*messagesAdapter.updateData(new Message(message, toWho, ActiveRecord.currentUser.getId()));
                messagesAdapter.notifyDataSetChanged();*/
                scrollMyListViewToBottom(message, true);
            }
        });
    }

    private StringBuffer sendSecure(String secureKey) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        String toHash = ActiveRecord.currentUser.getSalt() + secureKey;

        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(toHash.getBytes("UTF-8"));
        StringBuffer hexString = new StringBuffer();

        for (int i = 0; i < hash.length; i++) {
            String hex = Integer.toHexString(0xff & hash[i]);
            if(hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return (hexString);
    }

    private void scrollMyListViewToBottom(final String message, final boolean trigger) {
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                lv.post(new Runnable() {
                    @Override
                    public void run() {
                        // Select the last row so it will scroll into view...
                        if (trigger == true)
                            messagesAdapter.updateData(new Message(message, toWho, ActiveRecord.currentUser.getId()));
                        else
                            messagesAdapter.updateData(new Message(message, ActiveRecord.currentUser.getId(), friend.getId()));
                        messagesAdapter.notifyDataSetChanged();
                        lv.setSelection(lv.getCount() - 1);
                    }
                });
            }
        });
    }



}
