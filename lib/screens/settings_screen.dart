import 'package:explore/models/handle_delete_logout.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Screen",
                style: TextStyle(color: Colors.white, fontSize: 30)),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              iconSize: 50,
              onPressed: () {
                deleteAuthDetails();
                // deleteUserPhotosInCloudStorage();
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app_outlined),
              color: Colors.red,
              iconSize: 50,
              onPressed: () => logoutUser(),
            ),
          ],
        ),
    );
  }
}
