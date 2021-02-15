import 'package:explore/data/all_secure_storage.dart';
import 'package:explore/models/handle_deletes.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Home Screen",
                style: const TextStyle(color: Colors.white, fontSize: 30)),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              iconSize: 50,
              onPressed: () {
                deleteAuthDetails();
                // deleteUserPhotosInCloudStorage();
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app_outlined),
              color: Colors.red,
              iconSize: 50,
              onPressed: () => logoutUser(),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
              },
            ),
            IconButton(
              icon: const Icon(Icons.download_rounded),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
                readAll().then((value){
                  print(value);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever_rounded),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
                deleteAll();
              },
            ),
            IconButton(
              icon: const Icon(Icons.location_on),
              color: Colors.red,
              iconSize: 50,
              onPressed: (){
              },
            ),
          ],
        ),
    );
  }
}
