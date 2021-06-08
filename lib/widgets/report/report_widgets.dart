// @dart=2.9
// todo report widgets
import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/models/all_enums.dart';
import 'package:explore/providers/individual_chats_state.dart';
import 'package:explore/providers/pageview_logic.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:explore/server/star_report_backend/report.dart';
import 'package:explore/server/star_report_backend/report_rtdb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

void validateReports(
  ReportType selectedReportType,
  String oppositeUid,
  // check selectedreporttype and validate
) {
  if (selectedReportType == ReportType.fakeprofile) {
    Report.fakeProfile(oppositeUid);
  } else if (selectedReportType == ReportType.sexuallyExplicitContent) {
    Report.sexualExplicitContent(oppositeUid);
  } else if (selectedReportType == ReportType.imagesOfViolenceTorture) {
    Report.imagesOfViolenceTorture(oppositeUid);
  } else if (selectedReportType == ReportType.hateGroup) {
    Report.hateGroup(oppositeUid);
  } else if (selectedReportType == ReportType.illegalActivityAdvertising) {
    Report.illegalActivityAdvertising(oppositeUid);
  } else if (selectedReportType == ReportType.profileUnder18) {
    Report.profileUnder18(oppositeUid);
  } else if (selectedReportType == ReportType.hateSpeech) {
    Report.hateSpeech(oppositeUid);
  } else if (selectedReportType == ReportType.fakeLocation) {
    Report.fakeLocation(oppositeUid);
  } else if (selectedReportType == ReportType.notInterested) {
    ReportRTDB.reportAndBlock(oppositeUid, "Not interested");
  }
}

Future againstExploreDatingBottomSheet(
    String name, String oppositeUid, BuildContext context,
    {int index, String reportType, @required PreviewType previewType}) {
  return showBarModalBottomSheet(
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (context) => _AgainstExploreDating(
          name, oppositeUid, index, reportType, previewType));
}

class _AgainstExploreDating extends StatefulWidget {
  final String name;
  final String oppositeUid;
  final int index;
  final String reportType;
  final PreviewType previewType;
  _AgainstExploreDating(this.name, this.oppositeUid, this.index,
      this.reportType, this.previewType);

  @override
  __AgainstExploreDatingState createState() => __AgainstExploreDatingState();
}

class __AgainstExploreDatingState extends State<_AgainstExploreDating> {
  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height - 20;
    final double keyboardVisible = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: height,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Row(
            // goback , text
            children: [
              Container(
                // go back
                margin: const EdgeInsets.only(left: 10, top: 10),
                child: GestureDetector(
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Spacer(),
              Container(
                // text
                margin: const EdgeInsets.only(top: 10, right: 25),
                child: Text(
                  "Report",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Spacer(),
            ],
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // what makes user thinks ?
            margin: const EdgeInsets.only(top: 15, bottom: 10,left: 20,right: 10),
            child: Text(
              "What makes you think ${widget.name} is against explore dating community?.Tell us more what happended.",
              maxLines: 6,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            // text field
            width: double.infinity,
            margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
            child: Container(
              child: TextField(
                controller: _controller,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100), // max characters 100
                ],
                enabled: true,
                minLines: 1,
                maxLines: 4,
                cursorColor: Colors.white,
                cursorWidth: 3.0,
                // ! Need to use input text as WORDSANS
                style: const TextStyle(color: Colors.white, fontSize: 18),
                keyboardType: TextInputType.multiline,
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
                  hintText: "What happended?",
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          keyboardVisible != 0.0
              ? Padding(padding: const EdgeInsets.only(top: 10))
              : Spacer(),
          Container(
            // submit
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            // ignore: deprecated_member_use
            child: FlatButton(
              child: Text(
                "Submit",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).buttonColor, fontSize: 18),
              ),
              splashColor: Colors.red[600],
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  int popCount = 0;
                  Navigator.popUntil(context, (route) {
                    return popCount++ == 2;
                  });
                  Report.againstExploreDating(
                      widget.oppositeUid, _controller.text.trim());
                  greetReportFeedBackBottomSheet(widget.reportType, context,
                      index: widget.index, previewType: widget.previewType);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Future greetReportFeedBackBottomSheet(String reportType, BuildContext context,
    {int index, @required PreviewType previewType}) {
  return showBarModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (context) => _GreetReport(reportType, index, previewType));
}

class _GreetReport extends StatelessWidget {
  final String reportType;
  final int index;
  final PreviewType previewType;
  _GreetReport(this.reportType, this.index, this.previewType);
  @override
  Widget build(BuildContext context) {
    final pageViewLogic = Provider.of<PageViewLogic>(context, listen: false);
    return Container(
      height: 300,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            // check icon
            margin: const EdgeInsets.only(top: 15),
            child: Icon(Icons.check_circle,
                color: Theme.of(context).buttonColor, size: 50),
          ),
          Container(
            // greet feedback
            margin:
                const EdgeInsets.only(top: 40, left: 15, right: 10, bottom: 8),
            child: const Text(
              "Thank you for reporting this account.Your feedback is important in helping us keep Explore Dating community safe.",
              maxLines: 5,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Spacer(),
          Container(
            // close button
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            // ignore: deprecated_member_use
            child: FlatButton(
              child: Text(
                "Close",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).buttonColor, fontSize: 18),
              ),
              splashColor: Theme.of(context).buttonColor.withOpacity(0.5),
              onPressed: () {
                if (reportType.contains("feeds")) {
                  print("Reported via feeds");
                  pageViewLogic.holdExecution.value = true;
                  scrollUserDetails
                      .removeAt(index); // remove reported user from the list
                  if (PreviewType.feeds == previewType) {
                    Timer(
                        Duration(seconds: 1),
                        () => pageViewLogic.holdExecution.value =
                            false); // stop execution
                    int countPopScreen = 0;
                    Navigator.popUntil(context, (route) {
                      return countPopScreen++ == 2;
                    });
                  } else {
                    Timer(
                        Duration(seconds: 1),
                        () => pageViewLogic.holdExecution.value =
                            false); // stop execution
                    Navigator.pop(context);
                  }
                } else if (reportType.contains("chats")) {
                  print("Reported via chats");
                  final String chatPath =
                      Provider.of<IndividualChatState>(context, listen: false)
                          .tempChatPath;
                  final String oppostieUid =
                      Provider.of<IndividualChatState>(context, listen: false)
                          .tempOppositeUid;
                  unmatchIndividualChats(chatPath, oppostieUid);
                  int popCount = 0;
                  Navigator.popUntil(context, (route) {
                    return popCount++ == 2;
                  });
                } else {
                  print("By else statement in reports");
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget cannotReportHereFlushBar(BuildContext context) {
  // cannot report if pressed star
  // can report in conversations
  // report will be locked if user press star
  return Flushbar(
    backgroundColor: Color(0xff121212),
    messageText: Center(
      child: const Text(
        "You can report in conversation",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
    duration: Duration(seconds: 2),
  )..show(context);
}
