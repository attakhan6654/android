package mega.privacy.android.app.lollipop.controllers;

import android.app.Activity;
import android.content.Context;

import java.io.File;
import java.util.ArrayList;

import mega.privacy.android.app.DatabaseHandler;
import mega.privacy.android.app.MegaApplication;
import mega.privacy.android.app.MegaPreferences;
import mega.privacy.android.app.lollipop.ChatActivityLollipop;
import mega.privacy.android.app.lollipop.ManagerActivityLollipop;
import mega.privacy.android.app.lollipop.MyAccountFragmentLollipop;
import mega.privacy.android.app.lollipop.megachat.ContactChatInfoActivityLollipop;
import mega.privacy.android.app.utils.Util;
import nz.mega.sdk.MegaApiAndroid;
import nz.mega.sdk.MegaChatApi;
import nz.mega.sdk.MegaChatApiAndroid;
import nz.mega.sdk.MegaChatMessage;
import nz.mega.sdk.MegaChatRoom;
import nz.mega.sdk.MegaUser;

public class ChatController {

    Context context;
    MegaApiAndroid megaApi;
    MegaChatApiAndroid megaChatApi;
    DatabaseHandler dbH;
    MegaPreferences prefs = null;

    public ChatController(Context context){
        log("ChatController created");
        this.context = context;
        if (megaApi == null){
            megaApi = ((MegaApplication) ((Activity)context).getApplication()).getMegaApi();
        }
        if (megaChatApi == null){
            megaChatApi = ((MegaApplication) ((Activity)context).getApplication()).getMegaChatApi();
        }
        if (dbH == null){
            dbH = DatabaseHandler.getDbHandler(context);
        }
    }

    public void clearHistory(MegaChatRoom chat){
        log("clearHistory: "+chat.getTitle());
        if(context instanceof ManagerActivityLollipop){
            megaChatApi.clearChatHistory(chat.getChatId(), (ManagerActivityLollipop) context);
        }
        else if(context instanceof ChatActivityLollipop){
            megaChatApi.clearChatHistory(chat.getChatId(), (ChatActivityLollipop) context);
        }
        else if(context instanceof ContactChatInfoActivityLollipop){
            megaChatApi.clearChatHistory(chat.getChatId(), (ContactChatInfoActivityLollipop) context);
        }
    }

    public void deleteMessages(ArrayList<MegaChatMessage> messages, MegaChatRoom chat){
        log("deleteMessages: "+messages.size());
        MegaChatMessage messageToDelete;
        if(messages!=null){
            for(int i=0; i<messages.size();i++){
                messageToDelete = megaChatApi.deleteMessage(chat.getChatId(), messages.get(i).getMsgId());
                if(messageToDelete==null){
                    log("The message cannot be deleted");
                }
            }
        }
    }

    public static void log(String message) {
        Util.log("ChatController", message);
    }
}
