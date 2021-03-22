// @dart=2.9
import 'package:explore/messages/fcm_token.dart';
import 'package:explore/models/https_cloud_functions.dart';
import 'package:flutter/material.dart';


class ChatScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white30,
      child: Center(
        child: IconButton(
          icon: Icon(Icons.send,color: Colors.red,size: 30,),
          onPressed: (){
            // notifyUsersFCM();
            FCMToken.getFCMToken();
            callnotifyUsersFCMFunction(token: "fJdtQ5cvR6mdd9iLCSkNBp:APA91bG8d50FYNZUDhUGcGbQXUX-xr6dtRa5h5w80nHTS5lNWNZsEEzkmmsPDbqtLh9xQtxjS87vkPlMnncUacPaxkJtBK4tla2otT0c_HRyVS1CUBmyOVAvL2cxv0YIyhWe7ArbtLx-");
          },
        ),
      ),
    );
  }
}


// Lottie.asset("assets/animations/infinity.json",fit: BoxFit.cover),
