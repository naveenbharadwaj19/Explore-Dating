// @dart=2.9
import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/private/database_url_rtdb.dart';
import 'package:explore/server/handle_deletes_logout.dart';
import 'package:explore/server/match_backend/exclude_users.dart';
import 'package:explore/server/star_report_backend/report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Settings screen",
                style: const TextStyle(color: Colors.white, fontSize: 30)),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              iconSize: 50,
              onPressed: () {
                deleteAuthDetails(context);
                // deleteUserPhotosInCloudStorage();
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app_outlined),
              color: Colors.red,
              iconSize: 50,
              onPressed: () => logoutUser(context),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.red,
              iconSize: 50,
              onPressed: () {
              },
            ),
            IconButton(
              icon: const Icon(Icons.download_rounded),
              color: Colors.red,
              iconSize: 50,
              onPressed: () {
                readAll().then((value) {
                  print(value);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever_rounded),
              color: Colors.red,
              iconSize: 50,
              onPressed: () {
                deleteAll();
              },
            ),
            IconButton(
              icon: const Icon(Icons.location_on),
              color: Colors.red,
              iconSize: 50,
              onPressed: () {
                // BulkOperations.deleteNotificationFieldBulk();
                testRTDBQuery();
              },
            ),
          ],
        ),
    );
  }
}

testRTDBQuery()async{
  String myUid = FirebaseAuth.instance.currentUser.uid;
  DatabaseReference db = FirebaseDatabase(databaseURL: starInformationsRTDBUrl).reference();
  await db.child("$myUid/stars/jaoked5TipR9wZeKNpgWBr8bhWf1").remove();
}