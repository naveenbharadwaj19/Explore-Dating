// @dart=2.9
// todo report screen

import 'package:explore/models/all_enums.dart';
import 'package:explore/widgets/report/report_widgets.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future reportBottomSheet(String name, String oppositeUid, BuildContext context,
    {int index, String reportType = "feeds",@required PreviewType previewType}) {
  // types of report -> chats , feeds
  // default report type feeds
  return showBarModalBottomSheet(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    builder: (context) => _ReportScreen(name, oppositeUid, index, reportType,previewType),
  );
}

class _ReportScreen extends StatelessWidget {
  final String name;
  final String oppositeUid;
  final int index;
  final String reportType;
  final PreviewType previewType;
  _ReportScreen(this.name, this.oppositeUid, this.index, this.reportType,this.previewType);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Container(
              // report title
              height: 100,
              width: double.infinity,
              color: Theme.of(context).buttonColor.withOpacity(0.8),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(
                      "Report",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(
                      "Your report will be anonymous.We won't let them know it's you",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // fake profile
              width: double.infinity,
              margin: const EdgeInsets.all(7),
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Fake profile",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () => _reportSubmitBottomSheet(
                    name, oppositeUid, "as fake profile", context,
                    selectedReportType: ReportType.fakeprofile,
                    index: index,
                    reportType: reportType,previewType: previewType),
              ),
            ),
            const Divider(
              color: Colors.white54,
            ),
            Container(
              // inapporiate content
              width: double.infinity,
              margin: const EdgeInsets.all(7),
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Inapporiate content",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () => _reportInapporiateContentBottomSheet(
                    name, oppositeUid, context,
                    index: index, reportType: reportType,previewType: previewType),
              ),
            ),
            const Divider(
              color: Colors.white54,
            ),
            Container(
              // profile under 18
              width: double.infinity,
              margin: const EdgeInsets.all(7),
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Profile under 18",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () => _reportSubmitBottomSheet(
                    name, oppositeUid, "as under age", context,
                    selectedReportType: ReportType.profileUnder18,
                    index: index,
                    reportType: reportType,previewType: previewType),
              ),
            ),
            const Divider(
              color: Colors.white54,
            ),
            Container(
              // hate speech
              width: double.infinity,
              margin: const EdgeInsets.all(7),
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Hate speech",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () => _reportSubmitBottomSheet(
                    name, oppositeUid, "for outspreading hate speech", context,
                    selectedReportType: ReportType.hateSpeech,
                    index: index,
                    reportType: reportType,previewType: previewType),
              ),
            ),
            const Divider(
              color: Colors.white54,
            ),
            Container(
              // fake location
              width: double.infinity,
              margin: const EdgeInsets.all(7),
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Fake location",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () => _reportSubmitBottomSheet(
                    name, oppositeUid, "for spoofing location", context,
                    selectedReportType: ReportType.fakeLocation,
                    index: index,
                    reportType: reportType,previewType: previewType),
              ),
            ),
            const Divider(
              color: Colors.white54,
            ),
            Container(
              // against explore dating
              width: double.infinity,
              margin: const EdgeInsets.all(7),
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Against explore dating",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () => againstExploreDatingBottomSheet(
                    name, oppositeUid, context,
                    index: index, reportType: reportType,previewType: previewType),
              ),
            ),
            const Divider(
              color: Colors.white54,
            ),
            Container(
              // not interested
              width: double.infinity,
              margin: const EdgeInsets.all(7),
              // ignore: deprecated_member_use
              child: FlatButton(
                child: const Text(
                  "Not interested",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                splashColor: Theme.of(context).buttonColor,
                onPressed: () => _reportSubmitBottomSheet(
                    name, oppositeUid, "", context,
                    pressedNotInterested: true,
                    selectedReportType: ReportType.notInterested,
                    index: index,
                    reportType: reportType,previewType: previewType),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future _reportInapporiateContentBottomSheet(
    String name, String oppositeUid, BuildContext context,
    {int index, String reportType,@required PreviewType previewType}) {
  return showBarModalBottomSheet(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    builder: (context) =>
        _ReportInapporiateContent(name, oppositeUid, index, reportType,previewType),
  );
}

class _ReportInapporiateContent extends StatelessWidget {
  final String name;
  final String oppositeUid;
  final int index;
  final String reportType;
  final PreviewType previewType;
  _ReportInapporiateContent(
      this.name, this.oppositeUid, this.index, this.reportType,this.previewType);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            // report title
            height: 100,
            color: Theme.of(context).buttonColor.withOpacity(0.8),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    "Report",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    "Your report will be anonymous.We won't let them know it's you",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // sexual explicit content
            width: double.infinity,
            margin: const EdgeInsets.all(7),
            // ignore: deprecated_member_use
            child: FlatButton(
              child: const Text(
                "Sexual explicit content",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              splashColor: Theme.of(context).buttonColor,
              onPressed: () => _reportSubmitBottomSheet(
                  name, oppositeUid, "for sexual explicit content", context,
                  selectedReportType: ReportType.sexuallyExplicitContent,
                  pressedInapporiateContent: true,
                  index: index,
                  reportType: reportType,previewType: previewType),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // images of violence and torture
            width: double.infinity,
            margin: const EdgeInsets.all(7),
            // ignore: deprecated_member_use
            child: FlatButton(
              child: const Text(
                "Images of violence and torture",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              splashColor: Theme.of(context).buttonColor,
              onPressed: () => _reportSubmitBottomSheet(name, oppositeUid,
                  "for outspreading images of violence and torture", context,
                  selectedReportType: ReportType.imagesOfViolenceTorture,
                  pressedInapporiateContent: true,
                  index: index,
                  reportType: reportType,previewType: previewType),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // hate group
            width: double.infinity,
            margin: const EdgeInsets.all(7),
            // ignore: deprecated_member_use
            child: FlatButton(
              child: const Text(
                "Hate group",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              splashColor: Theme.of(context).buttonColor,
              onPressed: () => _reportSubmitBottomSheet(
                  name, oppositeUid, "for outspreading hate group", context,
                  selectedReportType: ReportType.hateGroup,
                  pressedInapporiateContent: true,
                  index: index,
                  reportType: reportType,previewType: previewType),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // illegal activity and advertising
            width: double.infinity,
            margin: const EdgeInsets.all(7),
            // ignore: deprecated_member_use
            child: FlatButton(
              child: const Text(
                "Illegal activity and advertising",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              splashColor: Theme.of(context).buttonColor,
              onPressed: () => _reportSubmitBottomSheet(name, oppositeUid,
                  "for illegal activity and advertising", context,
                  selectedReportType: ReportType.illegalActivityAdvertising,
                  pressedInapporiateContent: true,
                  index: index,
                  reportType: reportType,previewType: previewType),
            ),
          ),
        ],
      ),
    );
  }
}

Future _reportSubmitBottomSheet(
    String name, String oppositeUid, String reportTitle, BuildContext context,
    {bool pressedNotInterested = false,
    bool pressedInapporiateContent = false,
    int index,
    String reportType,
    @required ReportType selectedReportType, @required PreviewType previewType}) {
  return showBarModalBottomSheet(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    builder: (context) => _ReportSubmit(
        name,
        oppositeUid,
        reportTitle,
        pressedNotInterested,
        pressedInapporiateContent,
        selectedReportType,
        index,
        reportType,previewType),
  );
}

class _ReportSubmit extends StatelessWidget {
  final String name;
  final String oppositeUid;
  final String reportTile;
  final bool pressedNotInterested;
  final bool pressedInapporiateContent;
  final ReportType selectedReportType;
  final int index;
  final String reportType;
  final PreviewType previewType;
  _ReportSubmit(
      this.name,
      this.oppositeUid,
      this.reportTile,
      this.pressedNotInterested,
      this.pressedInapporiateContent,
      this.selectedReportType,
      this.index,
      this.reportType,
      this.previewType
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Container(
            // report title
            height: 100,
            width: double.infinity,
            color: Theme.of(context).buttonColor.withOpacity(0.8),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(5),
                  child: Text(
                    "Report",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    "Your report will be anonymous.We won't let them know it's you",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // submit confirmation
            width: double.infinity,
            margin:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 5),
            child: Text(
              pressedNotInterested
                  ? "Hide $name ?"
                  : "Sure ? want to report $name $reportTile.Press submit to report",
              maxLines: 4,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Spacer(),
          Container(
            // submit
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            // ignore: deprecated_member_use
            child: FlatButton(
              child: Text(
                pressedNotInterested ? "Yes" : "Submit",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).buttonColor, fontSize: 18),
              ),
              splashColor: Colors.red[600],
              onPressed: () {
                if (pressedInapporiateContent) {
                  int popCount = 0;
                  Navigator.popUntil(context, (route) {
                    return popCount++ == 3;
                  });
                  validateReports(
                    selectedReportType,
                    oppositeUid,
                  );
                  greetReportFeedBackBottomSheet(reportType, context,
                      index: index,previewType: previewType);
                } else {
                  int popCount = 0;
                  Navigator.popUntil(context, (route) {
                    return popCount++ == 2;
                  });
                  validateReports(selectedReportType, oppositeUid);
                  greetReportFeedBackBottomSheet(reportType, context,
                      index: index,previewType: previewType);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
