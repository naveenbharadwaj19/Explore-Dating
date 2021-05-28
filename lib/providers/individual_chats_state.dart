// @dart=2.9
// todo managle individual chats

import 'package:explore/server/chats/individual_chat_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// ICS individual chat State
class IndividualChatState extends ChangeNotifier {
  String tempChatPath = ""; // temp path of the chat
  String tempOppositeUid = "";  
  void sendToBackEnd({@required Map docData, @required String sendType,@required String path, @required BuildContext context,
      String onSubmittedText, TextEditingController messageController}) {
    //  when pressed send in keyboard or send icon
    //  sendType = sendButton , sendKeyboard
    if (sendType == "sendButton") {
      //  by send icon
      int docDataLen = docData["messages"].length;
      String message = messageController.text.trim();
      if (docDataLen == 1 && message.isNotEmpty) {
        IndividualChatBackEnd.boomMessage(
            message: message, path: path, uid1: docData["uid1"],context: context);
      } else if (message.isNotEmpty && message.contains("https://") ||
          message.contains("http://")) {
        // if message has url ink
        IndividualChatBackEnd.casualMessages(
            path: path, message: message,context: context,messageHasUrl: true);
      } else if (message.isNotEmpty) {
        IndividualChatBackEnd.casualMessages(path: path,message: message,context: context);
      }
    } else if (sendType == "sendKeyboard") {
      //  by keyboard
      int docDataLen = docData["messages"].length;
      String message = onSubmittedText.trim();
      if (docDataLen == 1 && message.isNotEmpty) {
        IndividualChatBackEnd.boomMessage(
            message: message, path: path, uid1: docData["uid1"],context: context);
      } else if (message.isNotEmpty && message.contains("https://") ||
          message.contains("http://")) {
        // if message has url ink
        IndividualChatBackEnd.casualMessages(
            path: path, message: message,context: context,messageHasUrl: true);
      } else if (message.isNotEmpty) {
        IndividualChatBackEnd.casualMessages(path: path,message: message,context: context);
      }
    }
    messageController.clear(); // clear the message
  }
  
}
