// @dart=2.9
// todo report backend rtdb
import 'package:explore/private/database_url_rtdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ReportRTDB {
  static String _myUid =
      FirebaseAuth.instance.currentUser.uid; // logged in user id
  static Future<void> reportAndBlock(
      String oppositeUid, String category) async {
    try {
      DatabaseReference db =
          FirebaseDatabase(databaseURL: reportBlockRTDBUrl).reference();
      // update my_uid
      await db.child("explicit_reports/$_myUid").update({
        "my_uid": _myUid,
      });
      // update explicit report data
      await db.child("explicit_reports/$_myUid/explicit_report_data").update({
        oppositeUid: {
          "reported_uid": oppositeUid,
          "reported_time": ServerValue.timestamp,
          "category": category
        }
      });
      // update gross reports
      await db.child("gross_reports/$_myUid").update({
        "my_email_address": FirebaseAuth.instance.currentUser.email ??
            "email address not found", // null check
        "my_uid": _myUid,
        "total_reported_accounts": ServerValue.increment(1),
      });
      // update report blocked uids
      await db.child('gross_reports/$_myUid/report_blocked_uids').update({
        oppositeUid: {
          "reported_uid": oppositeUid,
        }
      });
      print("report-block stored in rtdb");
    } catch (error) {
      print("Error in report and block rtdb : ${error.toString()}");
    }
  }
}
