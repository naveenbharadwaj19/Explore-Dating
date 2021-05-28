// @dart=2.9
// todo exclude reported , blocked , stared users
import 'package:explore/private/database_url_rtdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

Future<List<String>> doNotShowUsers() async {
  try {
    DatabaseReference db1 =
        FirebaseDatabase(databaseURL: starInformationsRTDBUrl).reference();
    DatabaseReference db2 =
        FirebaseDatabase(databaseURL: reportBlockRTDBUrl).reference();
    String myUid = FirebaseAuth.instance.currentUser.uid;
    List<String> reportedIds = [];
    List<String> starIds = [];
    // get starts ids
    var starDatas = await db1.child("$myUid/stars").once();
    Map starMap = starDatas.value ?? {}; // star datas as map if null empty map
    starMap.forEach((k, v) => starIds.add(k));
    // get report ids
    var reportDatas =
        await db2.child("gross_reports/$myUid/report_blocked_uids").once();
    Map reportMap =
        reportDatas.value ?? {}; // report datas as map if null empty map
    reportMap.forEach((k, v) => reportedIds.add(k));
    // merge two list and remove duplicates
    starIds.addAll(reportedIds);
    return starIds.toSet().toList();
  } catch (error) {
    print("Error in doNotShowUsers : ${error.toString()}");
    return [];
  }
}
