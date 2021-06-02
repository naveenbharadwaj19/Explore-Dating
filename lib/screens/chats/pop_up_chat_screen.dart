// @dart=2.9
// todo pop up chat screen

import 'package:cached_network_image/cached_network_image.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/models/all_enums.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/server/chats/pop_up_chat_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future popUpChatBottomSheet(
    int index, PreviewType previewType, BuildContext context) {
  return showBarModalBottomSheet(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    isDismissible: false,
    enableDrag: false,
    builder: (context) => _PopUpChat(index,previewType),
  );
}

class _PopUpChat extends StatelessWidget {
  final int index;
  final PreviewType previewType;
  _PopUpChat(this.index, this.previewType);
  @override
  Widget build(BuildContext context) {
    final double keyboardVisible = MediaQuery.of(context).viewInsets.bottom;
    final double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).primaryColor,
        height: keyboardVisible == 0.0 ? 450 : height,
        child: Column(
          children: [
            Container(
              // ? title , close button
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Container(
                    // ? title
                    margin: const EdgeInsets.only(left: 15),
                    child: const Text(
                      "Something here", // ! this title doesn't make sense
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    // ? close button
                    margin: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Theme.of(context).buttonColor,
                        size: 30,
                      ),
                      onTap: () {
                        String name = scrollUserDetails[index]["name"];
                        String uid = scrollUserDetails[index]["uid"];
                        String oppositHeadPhotoUrl =
                            scrollUserDetails[index]["headphoto"];
                        storeChatData(
                            oppositeUid: uid,
                            oppositeName: name,
                            oppositeHeadPhotoUrl: oppositHeadPhotoUrl);
                        if (PreviewType.feeds == previewType) {
                          int countPopScreen = 0;
                          Navigator.popUntil(context, (route) {
                            return countPopScreen++ == 2;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              // ? horizontal divider
              color: Colors.white54,
            ),
            Container(
              // ? head photo
              margin: const EdgeInsets.only(top: 20),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xff121212),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: scrollUserDetails[index]["headphoto"].toString(),
                    fit: BoxFit.cover,
                    placeholder: (context, url) => BlurHash(
                      hash: scrollUserDetails[index]["hp_hash"],
                      imageFit: BoxFit.cover,
                      color: Color(0xff121212).withOpacity(0),
                      curve: Curves.slowMiddle,
                      // image: scrollUserDetails[index]["headphoto"].toString(),
                    ),
                    errorWidget: (context, url, error) =>
                        whileHeadImageloadingSpinner(),
                  ),
                ),
              ),
            ),
            Container(
              // ? name
              margin: const EdgeInsets.only(top: 20),
              child: Text(
                scrollUserDetails[index]["name"],
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Container(
              // ? disapper info
              margin: const EdgeInsets.only(top: 30, left: 5, right: 5),
              child: Text(
                "Will unmatch if ${scrollUserDetails[index]["name"]} didn't respond within 12hrs",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            keyboardVisible == 0.0
                ? Spacer()
                : Container(margin: const EdgeInsets.only(top: 10, bottom: 10)),
            _MessageBox(index,previewType),
          ],
        ),
      ),
    );
  }
}

class _MessageBox extends StatefulWidget {
  final int index;
  final PreviewType previewType;
  _MessageBox(this.index, this.previewType);

  @override
  __MessageBoxState createState() => __MessageBoxState();
}

class __MessageBoxState extends State<_MessageBox> {
  TextEditingController sendController = TextEditingController();
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    sendController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Container(
              child: TextField(
                controller: sendController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50), // max characters 50
                ],
                textCapitalization: TextCapitalization.sentences,
                enabled: true,
                minLines: 1,
                maxLines: 2,
                cursorColor: Colors.white,
                cursorWidth: 3.0,
                textInputAction: TextInputAction.send,
                onSubmitted: (message) {
                  if (message.isNotEmpty) {
                    // print(message);
                    String name = scrollUserDetails[widget.index]["name"];
                    String uid = scrollUserDetails[widget.index]["uid"];
                    String oppositHeadPhotoUrl =
                        scrollUserDetails[widget.index]["headphoto"];
                    String messageContent = message.trim();
                    storeChatData(
                        oppositeName: name,
                        oppositeUid: uid,
                        messageContent: messageContent,
                        oppositeHeadPhotoUrl: oppositHeadPhotoUrl);
                    if (PreviewType.feeds == widget.previewType) {
                      int countPopScreen = 0;
                      Navigator.popUntil(context, (route) {
                        return countPopScreen++ == 2;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
                // ! Need to use input text as WORDSANS
                style: const TextStyle(color: Colors.white, fontSize: 18),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).buttonColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Theme.of(context).buttonColor, width: 2),
                  ),
                  hintText: "Type here ...",
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
          child: GestureDetector(
            child: Icon(
              Icons.send_rounded,
              size: 30,
              color: Theme.of(context).buttonColor,
            ),
            onTap: () {
              if (sendController.text.isNotEmpty) {
                // print(sendController.text);
                String name = scrollUserDetails[widget.index]["name"];
                String uid = scrollUserDetails[widget.index]["uid"];
                String oppositHeadPhotoUrl =
                    scrollUserDetails[widget.index]["headphoto"];
                String messageContent = sendController.text.trim();
                storeChatData(
                    oppositeName: name,
                    oppositeUid: uid,
                    messageContent: messageContent,
                    oppositeHeadPhotoUrl: oppositHeadPhotoUrl);
                if (PreviewType.feeds == widget.previewType) {
                  int countPopScreen = 0;
                  Navigator.popUntil(context, (route) {
                    return countPopScreen++ == 2;
                  });
                } else {
                  Navigator.pop(context);
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
