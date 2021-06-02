// @dart=2.9
// todo when user press report button

import 'dart:async';
import 'package:explore/models/all_enums.dart';
import 'package:explore/screens/report/report_screen.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future reportChatPopUpsheet(String path,String name,String oppositeUid,BuildContext context) {
  return showBarModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      builder: (context) => _ReportChatPopUp(path,name,oppositeUid,context));
}

class _ReportChatPopUp extends StatelessWidget {
  final String path;
  final String name;
  final String oppositeUid;
  final BuildContext contextP;
  _ReportChatPopUp(this.path,this.name,this.oppositeUid,this.contextP);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 170,
      child: Column(
        children: [
          Container(
            // ? unmatch
            margin: const EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Unmatch",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () {
                  print("Pressed unmatch");
                  if(path.isNotEmpty){
                    unmatchIndividualChats(path,oppositeUid); // * R - number of rooms , D - number of rooms
                  }
                  int counter = 0;
                  Navigator.popUntil(context, (route){
                    return counter ++ == 2; // pop off report screen and inidivdual chat screen
                  });
                },
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // ? report & block
            margin: const EdgeInsets.only(top: 15),
            child: Container(
              width: double.infinity,
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Report & Block",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () {
                  print("Pressed report & block");
                  Navigator.pop(context);
                  reportBottomSheet(name, oppositeUid, context,reportType: "chats",previewType: PreviewType.individualChat);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
