// @dart=2.9
// todo individual chat screen

import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/icons/gallery_icon_icons.dart';
import 'package:explore/icons/report_filter_icons_icons.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/private/database_url_rtdb.dart';
import 'package:explore/providers/individual_chats_state.dart';
import 'package:explore/server/chats/individual_chat_backend.dart';
import 'package:explore/widgets/chats/handle_photos_ind_chats.dart';
import 'package:explore/widgets/chats/url_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

// ? top - app bar
// ? middle - content (messages)
// ? lower - input fields

class IndividualChatScreen extends StatefulWidget {
  static const routeName = "individual-chat-screen";

  @override
  _IndividualChatScreenState createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final String myUid = FirebaseAuth.instance.currentUser.uid;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Map docData;
  String path = "";
  ScrollController controller = ScrollController();
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    docData.clear();
    path = "";
  }

  @override
  Widget build(BuildContext context) {
    final arugments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _appBar(myUid, arugments["name"], arugments["head_photo"],
          arugments["path"], context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(arugments["path"])
            .where("uids", arrayContains: myUid)
            .orderBy("latest_time", descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, messageSnapShot) {
          if (messageSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: loadingSpinner());
          }
          if (messageSnapShot.hasError || !messageSnapShot.hasData) {
            print("Error in messagesnapshot");
            return Center(child: loadingSpinner());
          }
          List<QueryDocumentSnapshot> unZip = messageSnapShot.data.docs;
          unZip.forEach((e) {
            docData = e.data();
            path = e.reference.path;
          });
          return Column(
            children: [
              Expanded(
                  child: _Middle(
                path: path,
                myUid: myUid,
                docData: docData,
                controller: controller,
              )),
              _Lower(docData, path, controller, scaffoldKey.currentContext),
            ],
          );
        },
      ),
    );
  }
}

Widget _appBar(String myUid, String name, String headPhoto, String path,
    BuildContext context) {
  // ? Top
  String docId = path.split("/")[1];
  return AppBar(
    toolbarHeight: 80,
    backwardsCompatibility: false,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.black12, // status bar color
      statusBarIconBrightness: Brightness
          .light, // text brightness -> light for dark app -> vice versa
    ),
    backgroundColor: Theme.of(context).primaryColor,
    title: Stack(
      children: [
        Container(
          // ? head photo
          margin: const EdgeInsets.only(top: 5, left: 8),
          child: GestureDetector(
            child: CircleAvatar(
              radius: 33,
              backgroundColor: Color(0xff121212),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: headPhoto,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: whileHeadImageloadingSpinner()),
                  errorWidget: (context, url, error) => Center(
                    child: const Text(
                      "Error 500",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {
              // todo navigate to preview
              print("Preview");
            },
          ),
        ),
        Container(
          // ? name
          margin: const EdgeInsets.only(top: 20, left: 85),
          alignment: Alignment.topLeft,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        StreamBuilder(
          stream: FirebaseDatabase(databaseURL: dataBaseUrlRTDB)
              .reference()
              .child(docId)
              .onValue,
          builder: (context, typingSnapShot) {
            if (!typingSnapShot.hasData || typingSnapShot.hasError) {
              print("Something went wrong in typing snapshot");
              return Container();
            }
            bool isTyping;
            Map data = typingSnapShot.data.snapshot.value;
            // opposite user typing data
            data.forEach((key, value) {
              if (key != myUid) {
                isTyping = value;
              }
            });
            return Container(
              // ? typing
              margin: const EdgeInsets.only(top: 43, left: 85),
              alignment: Alignment.topLeft,
              child: Text(
                isTyping ?? false ? "Typing..." : "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            );
          },
        ),
      ],
    ),
    actions: [
      // ? report
      Container(
        margin: const EdgeInsets.only(top: 3, right: 10, left: 3),
        child: GestureDetector(
          child: const Icon(
            ReportFilterIcons.report_100_px_new,
            size: 45,
            color: Colors.white70,
          ),
          onTap: () {
            print("report pop up");
            // todo
            // todo add report functions ...
          },
        ),
      ),
    ],
  );
}

class _Middle extends StatelessWidget {
  final Map docData;
  final String myUid;
  final ScrollController controller;
  final BuildContext contextP;
  final String path;
  _Middle(
      {this.myUid, this.path, this.docData, this.controller, this.contextP});

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(milliseconds: 110),
      () => controller.jumpTo(controller.position.maxScrollExtent),
    );
    return ListView.builder(
      itemCount: docData["messages"].length,
      controller: controller,
      itemBuilder: (context, index) {
        final bool isMe =
            docData["messages"][index]["sender_uid"] == myUid ? true : false;
        return Container(
          margin: EdgeInsets.all(10),
          child: Bubble(
            // ? bubble chat
            margin: !isMe
                ? BubbleEdges.only(right: 70)
                : BubbleEdges.only(left: 70),
            alignment: !isMe ? Alignment.topLeft : Alignment.topRight,
            nip: !isMe ? BubbleNip.leftTop : BubbleNip.rightTop,
            radius: const Radius.circular(15),
            borderColor: !isMe ? Theme.of(context).buttonColor : Colors.white54,
            borderWidth: 2,
            color: Theme.of(context).primaryColor,
            stick: true,
            child: docData["messages"][index]["show_url_preview"]
                ? PreviewUrl(docData["messages"][index]["msg_content"])
                : docData["messages"][index]["msg_content"]
                        .contains("https://firebasestorage.googleapis.com")
                    ? _TapToView(docData["messages"][index], path)
                    : AutoSizeText(
                        docData["messages"][index]["msg_content"].toString(),
                        minFontSize: 18,
                        maxFontSize: 18,
                        maxLines: 15,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
          ),
        );
      },
    );
  }
}

class _Lower extends StatefulWidget {
  final Map docData;
  final String path;
  final ScrollController controller;
  final BuildContext scaffoldContext;
  _Lower(this.docData, this.path, this.controller, this.scaffoldContext);
  @override
  __LowerState createState() => __LowerState();
}

class __LowerState extends State<_Lower> {
  TextEditingController messageController = TextEditingController();
  String myUid = FirebaseAuth.instance.currentUser.uid;
  bool conversationLocked() {
    //  check if conversation is locked
    List canSend = widget.docData["can_send"];
    int index = canSend.indexWhere((e) => e["uid"] == myUid);
    bool permission = widget.docData["can_send"][index]["permission"];
    return permission;
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
    widget.docData.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Map docData = widget.docData;
    final individualChatState =
        Provider.of<IndividualChatState>(context, listen: false);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          // ? upload options
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              child: Icon(
                Icons.add_circle_outline_rounded,
                size: 35,
                color: docData["doc_limit"] <= 10 && !docData["can_send_photos"]
                    ? Theme.of(context).buttonColor.withOpacity(0.7)
                    : Theme.of(context).buttonColor,
              ),
              onTap: () {
                if (docData["can_send_photos"]) {
                  _photoPopUpBottomSheet(widget.path, widget.scaffoldContext);
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 15, bottom: 3),
              child: AbsorbPointer(
                absorbing: !conversationLocked()
                    ? true
                    : false, // check if uid1 can start conversation
                child: TextField(
                  controller: messageController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(350), // max characters 350
                  ],
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (text) => individualChatState.sendToBackEnd(
                    docData: docData,
                    sendType: "sendKeyboard",
                    path: widget.path,
                    onSubmittedText: text,
                    messageController: messageController,
                    context: context
                  ),
                  onEditingComplete: () {}, // prevent keyboard from closing
                  onTap: () {
                    Timer(
                        Duration(milliseconds: 150),
                        () => widget.controller.jumpTo(
                            widget.controller.position.maxScrollExtent));
                  }, // when textfield is tapped
                  onChanged: (_) {
                    IndividualChatBackEnd.detectTyping(widget.path, myUid);
                    Timer(Duration(seconds: 2), () {
                      IndividualChatBackEnd.detectTyping(widget.path, myUid,
                          isTyping: false);
                    });
                  },
                  enabled: true,
                  minLines: 1,
                  maxLines: 3,
                  cursorColor: Colors.white,
                  cursorWidth: 3.0,
                  // ! Need to use input text as WORDSANS
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Theme.of(context).buttonColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Theme.of(context).buttonColor, width: 2),
                    ),
                    hintText:
                        !conversationLocked() ? "Locked..." : "Type here ...",
                    hintStyle: const TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
          Container(
            // ? send button
            margin: const EdgeInsets.only(right: 5),
            child: AbsorbPointer(
              absorbing: !conversationLocked()
                  ? true
                  : false, // check if uid1 can start conversation
              child: GestureDetector(
                child: Icon(
                  Icons.send_rounded,
                  size: 30,
                  color: !conversationLocked()
                      ? Theme.of(context).buttonColor.withOpacity(0.7)
                      : Theme.of(context).buttonColor,
                ),
                onTap: () => individualChatState.sendToBackEnd(
                    docData: docData,
                    sendType: "sendButton",
                    path: widget.path,
                    messageController: messageController,
                    context: context,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ? when plus button is pressed
Future _photoPopUpBottomSheet(String path, BuildContext contextP) {
  // * contextP -> contextParent of UserPrespectiveScreen
  return showBarModalBottomSheet(
      context: contextP,
      backgroundColor: Theme.of(contextP).primaryColor,
      builder: (contextP) => _PhotoPopUp(path, contextP));
}

class _PhotoPopUp extends StatelessWidget {
  final String path;
  final BuildContext contextP;
  _PhotoPopUp(this.path, this.contextP);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 300,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // ? camera button
            margin: const EdgeInsets.only(top: 50),
            height: 70,
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              icon: const Icon(
                Icons.camera_alt_rounded,
                size: 40,
                color: Color(0xffF8C80D),
              ),
              splashColor: Colors.white,
              color: Colors.white,
              textColor: Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text(
                "Camera",
                style: const TextStyle(fontSize: 25),
              ),
              onPressed: () {
                print("Pressed camera");
                HandlePhotosForIndividualChat.openCamera(path, contextP);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
          ), // outer spacing
          Container(
            // ? gallery button
            height: 70,
            width: 180,
            // ignore: deprecated_member_use
            child: RaisedButton.icon(
              icon: const Icon(
                GalleryIcon.picture,
                size: 40,
                color: Color(0xffF8C80D),
              ),
              splashColor: Colors.white,
              color: Colors.white,
              textColor: Color(0xff121212),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              label: Text(
                "Gallery",
                style: const TextStyle(fontSize: 25),
              ),
              onPressed: () {
                print("Pressed gallery");
                HandlePhotosForIndividualChat.openGallery(path, contextP);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TapToView extends StatelessWidget {
  final Map messageDoc;
  final String path;
  _TapToView(this.messageDoc, this.path);
  final myUid = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    final String url = messageDoc["msg_content"];
    final String senderUid = messageDoc["sender_uid"];
    final DateTime timeSent = messageDoc["time_sent"].toDate();
    return GestureDetector(
      child: const AutoSizeText(
        "Tap to view",
        maxLines: 1,
        minFontSize: 18,
        maxFontSize: 18,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      onTap: () {
        Navigator.pushNamed(context, ViewPhoto.routeName,
            arguments: url); // open image
        Timer(Duration(seconds: 11), () {
          if (myUid != senderUid) {
            IndividualChatBackEnd.deletePhotoFromDb(
                url, senderUid, timeSent, path);
          }
        });
      },
    );
  }
}

class ViewPhoto extends StatelessWidget {
  static const routeName = "view-photo";
  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context).settings.arguments;
    return Container(
      // * show user original image
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(top: 35, right: 10),
            child: CircularCountDownTimer(
              // ? countdown timer
              width: 30,
              height: 30,
              duration: 10,
              fillColor: Theme.of(context).buttonColor,
              ringColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).primaryColor,
              strokeWidth: 2,
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none),
              onComplete: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Center(child: loadingSpinner()),
              errorWidget: (context, url, error) => Center(
                child: const Text(
                  "Error 500",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
