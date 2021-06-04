// @dart=2.9
// todo chat screen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:explore/icons/hour_glass_icons.dart';
import 'package:explore/models/all_enums.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/screens/chats/individual_chat_screen.dart';
import 'package:explore/screens/profile/preview_screen.dart';
import 'package:explore/server/chats/chat_backend.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    ChatBackEnd.chatData.clear();
    ChatBackEnd.deleteDatas.clear();
    ChatBackEnd.showLoadingSpineer = true;
    ChatBackEnd.latestTimeStr = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black12, // status bar color
          statusBarIconBrightness: Brightness
              .light, // text brightness -> light for dark app -> vice versa
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 70,
        title: Container(
          margin: const EdgeInsets.only(top: 5),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(children: [
              const TextSpan(
                text: "Explore\n",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
              const TextSpan(
                text: "Dating",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
            ]),
          ),
        ),
      ),
      body: FutureBuilder(
        future: ChatBackEnd.displayChats(),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            print("Error in displayChats");
            return Center(child: loadingSpinner());
          }
          return ValueListenableBuilder(
            valueListenable: ChatBackEnd.processChatDatas,
            builder: (_, value, __) {
              if (value && ChatBackEnd.showLoadingSpineer) {
                print("Chat data processing");
                return Center(child: loadingSpinner());
              }
              return _Chats();
            },
          );
        },
      ),
    );
  }
}

class _Chats extends StatelessWidget {
  final String myUid = FirebaseAuth.instance.currentUser.uid;
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ChatBackEnd.chatData.isEmpty
        ? _NoMessage()
        : NotificationListener<ScrollEndNotification>(
            onNotification: (scrollDetails) {
              if (scrollDetails.metrics.atEdge) {
                if (scrollDetails.metrics.pixels != 0) {
                  if (ChatBackEnd.latestTimeStr.isNotEmpty) {
                    print("Scrolled down");
                    ChatBackEnd.displayChats();
                  }
                }
              }
              return true;
            },
            child: ListView.builder(
              controller: _controller,
              itemCount: ChatBackEnd.chatData.length,
              itemBuilder: (context, index) {
                bool isMe = ChatBackEnd.chatData[index]["sender_uid"] == myUid
                    ? true
                    : false;
                return Container(
                  margin: const EdgeInsets.only(top: 15), // each stack control
                  child: GestureDetector(
                    child: Container(
                      color: Theme.of(context)
                          .primaryColor, // removing will affect gesture detector
                      child: Stack(
                        children: [
                          Container(
                            // ? head photo
                            margin: const EdgeInsets.only(top: 10, left: 30),
                            // alignment: Alignment.topLeft,
                            child: GestureDetector(
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: Color(0xff121212),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: ChatBackEnd.chatData[index]
                                        ["head_photo"],
                                    placeholder: (context, url) => Center(
                                        child: whileHeadImageloadingSpinner()),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: const Text(
                                        "Error 500",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onLongPress: () => Navigator.pushNamed(
                                  context, PreviewScreen.routeName,
                                  arguments: {
                                    "uid": ChatBackEnd.chatData[index]
                                        ["opposite_uid"],
                                    "preview_type": PreviewType.chats,
                                    "index": 9999
                                  }),
                            ),
                          ),
                          Container(
                            // ? name
                            margin: const EdgeInsets.only(top: 20, left: 120),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ChatBackEnd.chatData[index]["name"].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Container(
                            // ? last message
                            margin: const EdgeInsets.only(top: 55, left: 120),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ChatBackEnd.chatData[index]["show_url_preview"]
                                  ? "Shared a link"
                                  : ChatBackEnd.chatData[index]["last_message"]
                                          .contains(
                                              "https://firebasestorage.googleapis.com")
                                      ? "Sent a photo"
                                      : ChatBackEnd.chatData[index]
                                              ["last_message"]
                                          .toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: isMe
                                      ? Colors.white70
                                      : Theme.of(context).buttonColor,
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                              // ? vanish icon
                              margin: const EdgeInsets.only(top: 30, right: 20),
                              alignment: Alignment.centerRight,
                              child: !ChatBackEnd.chatData[index]
                                      ["automatic_unmatch"]
                                  ? Container()
                                  : Icon(
                                      HourGlass.hourglass,
                                      size: 20,
                                      color: Theme.of(context).buttonColor,
                                    )),
                        ],
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(
                        context, IndividualChatScreen.routeName,
                        arguments: {
                          "name": ChatBackEnd.chatData[index]["name"],
                          "head_photo": ChatBackEnd.chatData[index]
                              ["head_photo"],
                          "path": ChatBackEnd.chatData[index]["path"],
                          "opposite_uid": ChatBackEnd.chatData[index]
                              ["opposite_uid"],
                        }),
                  ),
                );
              },
            ),
          );
  }
}

class _NoMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // ? animation
            child: Lottie.asset(
              "assets/animations/no_message.json",
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            // ? text
            margin: const EdgeInsets.only(top: 30),
            child: const Text(
              "---------- Ux writing----------",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
