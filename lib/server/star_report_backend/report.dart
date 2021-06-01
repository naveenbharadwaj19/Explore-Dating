// @dart=2.9
// todo report backend
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/server/star_report_backend/report_rtdb.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ntp/ntp.dart';

class Report {
  static Future<void> fakeProfile(String oppositeUid) async {
    String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      ReportRTDB.reportAndBlock(oppositeUid, "Fake profile");
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Fakeprofile/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Fakeprofile/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in fakeprofile : ${error.toString()}");
      }
    }
  }

  static Future<void> sexualExplicitContent(String oppositeUid) async {
    // parent of inapporiate content
     String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
     
      ReportRTDB.reportAndBlock(oppositeUid, "Sexual explicit content");
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Inapporiatecontent/4content/Sexuallyexplicitcontent/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Inapporiatecontent/4content/Sexuallyexplicitcontent/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in sexuallyexplicitcontent : ${error.toString()}");
      }
    }
  }

  static Future<void> imagesOfViolenceTorture(String oppositeUid) async {
    // parent of inapporiate content
     String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      ReportRTDB.reportAndBlock(oppositeUid, "Images of violence and torture");
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Inapporiatecontent/4content/Imagesofviolencetorture/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Inapporiatecontent/4content/Imagesofviolencetorture/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in imagesofviolencetorture : ${error.toString()}");
      }
    }
  }

  static Future<void> hateGroup(String oppositeUid) async {
    // parent of inapporiate content
     String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      ReportRTDB.reportAndBlock(oppositeUid, "Hate group");
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Inapporiatecontent/4content/Hategroup/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Inapporiatecontent/4content/Hategroup/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in hategroup : ${error.toString()}");
      }
    }
  }

  static Future<void> illegalActivityAdvertising(String oppositeUid) async {
    // parent of inapporiate content
     String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      ReportRTDB.reportAndBlock(
          oppositeUid, "Illegal activity and advertising");
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Inapporiatecontent/4content/Illegalactivityadvertising/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Inapporiatecontent/4content/Illegalactivityadvertising/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in illegalactivityadvertising : ${error.toString()}");
      }
    }
  }

  static Future<void> profileUnder18(String oppositeUid) async {
     String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      ReportRTDB.reportAndBlock(oppositeUid, "Profile under 18");
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Profileunder18/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Profileunder18/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in profileunder18 : ${error.toString()}");
      }
    }
  }

  static Future<void> hateSpeech(String oppositeUid) async {
     String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      ReportRTDB.reportAndBlock(oppositeUid, "Hate speech");
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Hatespeech/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Hatespeech/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in hatespeech : ${error.toString()}");
      }
    }
  }

  static Future<void> fakeLocation(String oppositeUid) async {
     String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      ReportRTDB.reportAndBlock(oppositeUid, "Spoofing location");
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Fakelocation/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Fakelocation/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in fakelocation : ${error.toString()}");
      }
    }
  }

  static Future<void> againstExploreDating(
      String oppositeUid, String explicitReason) async {
         String myUid = FirebaseAuth.instance.currentUser.uid;
    try {
      ReportRTDB.reportAndBlock(oppositeUid, explicitReason);
      DateTime nTPTimeStamp = await NTP.now();
      String fakeProfilePath =
          "Users/$oppositeUid/Redflags/allredflags/Againstexploredating/docdata";
      DocumentReference flageUser =
          FirebaseFirestore.instance.doc(fakeProfilePath);
      await flageUser.update({
        "reported_me": FieldValue.increment(1),
        "red_flag": FieldValue.arrayUnion([
          {
            "reported_uid": myUid,
            "reported_time": nTPTimeStamp,
          }
        ]),
      });
      print("Flagged $oppositeUid as fakeprofile");
    } catch (error) {
      if (error.toString().contains(
          "[cloud_firestore/not-found] Some requested document was not found.")) {
        DateTime nTPTimeStamp = await NTP.now();
        String fakeProfilePath =
            "Users/$oppositeUid/Redflags/allredflags/Againstexploredating/docdata";
        DocumentReference flageUser =
            FirebaseFirestore.instance.doc(fakeProfilePath);
        await flageUser.set({
          "reported_me": FieldValue.increment(1),
          "red_flag": FieldValue.arrayUnion([
            {"reported_uid": myUid, "reported_time": nTPTimeStamp}
          ]),
        });
        print("No red flag collection found so created one");
      } else {
        print("Error in againstexploredating : ${error.toString()}");
      }
    }
  }
}
