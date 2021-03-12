import 'package:flutter/material.dart';


class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(icon: Icon(Icons.fireplace,color: Colors.red,), onPressed:(){
        // FirebaseCrashlytics.instance.crash();

        
      })
    );
  }
}


// Lottie.asset("assets/animations/infinity.json",fit: BoxFit.cover),