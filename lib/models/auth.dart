import 'package:Explore/screens/emai_verf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationFirebase {
  static void signInUser(
      { @required TextEditingController emailAddress,
      @required TextEditingController password,
      @required Function loadingOn,
      @required Function loadingOff,
      @required BuildContext ctx}) async {
    final auth = FirebaseAuth.instance;
    UserCredential userResult;
    // userResult = await auth.createUserWithEmailAndPassword(email: emailAddress.text, password: password.text);
    try {
      loadingOn();
      userResult = await auth.createUserWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      loadingOff();
      
      auth.authStateChanges().listen((User user) { 
        if (user != null){
          print("User acc created ...");
          Navigator.pushNamed(ctx, EmailVerificationScreen.routeName);
        }
      });

    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Flushbar(
        backgroundColor: Color(0xff121212),
        messageText: Text(message.toString(),style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,color: Colors.white),),
        duration: Duration(seconds: 3),
      )..show(ctx);

      loadingOff();

    } catch (err) {
      print("Error : $err");
      if (err.toString().contains(
          "The email address is already in use by another account.")) {
        Flushbar(
          messageText: Text("Email address exist",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,color: Colors.white),),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);

      } else if (err.toString().contains(
          " The password is invalid or the user does not have a password.")) {
        Flushbar(
          messageText: Text("Incorrect password",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,color: Colors.white),),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else {
        Flushbar(
          messageText: Text("Something went wrong try again",style: TextStyle(fontFamily: "OpenSans",fontWeight: FontWeight.w700,color: Colors.white),),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      }
      loadingOff();
    }
  }
}
