import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/serverless/connecting_users.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Column(
          children: [
            IconButton(
                icon: const Icon(Icons.data_usage),
                color: Colors.white,
                iconSize: 50,
                onPressed: () {
                  ConnectingUsers.basicUserConnection();
                },
              ),
              IconButton(
                icon: const Icon(Icons.memory),
                color: Colors.white,
                iconSize: 50,
                onPressed: () {
                  print(scrollUserDetails);
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,
                iconSize: 50,
                onPressed: () {
                  int i = ConnectingUsers.limit;
                  i += 1;
                  ConnectingUsers.limit = i;
                  print(ConnectingUsers.limit);
                },
              ),
          ],
        ),
      ),
    );
  }
}