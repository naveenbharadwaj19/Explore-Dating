
import 'package:explore/data/temp/store_basic_match.dart';
import 'package:explore/models/serverless/connecting_users.dart';
import 'package:flutter/material.dart';

// todo : Feeds of dating
class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      child : Column(
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
                print(scrollUserDetails.length);
              },
            ),
        ],
      ),
    );
  }
}