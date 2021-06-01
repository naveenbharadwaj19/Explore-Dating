// @dart=2.9
// todo report backend rtdb
import 'package:explore/private/database_url_rtdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReportRTDB {
  static Future<void> reportAndBlock(
      String oppositeUid, String category) async {
        String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      DatabaseReference db =
          FirebaseDatabase(databaseURL: reportBlockRTDBUrl).reference();
      print("my uid : $myUid , oppo : $oppositeUid");
      // update my_uid
      await db.child("explicit_reports/$myUid").update({
        "my_uid": myUid,
      });
      // update explicit report data
      await db.child("explicit_reports/$myUid/explicit_report_data").update({
        oppositeUid: {
          "reported_uid": oppositeUid,
          "reported_time": ServerValue.timestamp,
          "category": category
        }
      });
      // update gross reports
      await db.child("gross_reports/$myUid").update({
        "my_email_address": FirebaseAuth.instance.currentUser.email ??
            "email address not found", // null check
        "my_uid": myUid,
        "total_reported_accounts": ServerValue.increment(1),
      });
      // update report blocked uids
      await db.child('gross_reports/$myUid/report_blocked_uids').update({
        oppositeUid: {
          "reported_uid": oppositeUid,
        }
      });
      // ------
      // update opposite uid
      await db.child("gross_reports/$oppositeUid").update({
        "my_uid" : oppositeUid,
        "no_of_accounts_reported_me" : ServerValue.increment(1)
      });
      await db.child('gross_reports/$oppositeUid/report_blocked_uids').update({
        myUid : {
          "reported_uid" : myUid
        }
      });

      print("report-block stored in rtdb");
    } catch (error) {
      print("Error in report and block rtdb : ${error.toString()}");
    }
  }
}
