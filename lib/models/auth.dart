import 'package:Explore/data/auth_data.dart';
import 'package:Explore/models/email_model.dart';
import 'package:Explore/models/firestore_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthenticationFirebase {
  static void signInUser(
      {@required String emailAddress,
      @required String password,
      @required Function loadingOn,
      @required Function loadingOff,
      @required String username,
      @required BuildContext ctx}) async {
    final auth = FirebaseAuth.instance;
    UserCredential userResult;

    try {
      loadingOn();
      userResult = await auth.createUserWithEmailAndPassword(
          email: emailAddress, password: password);
      OnlyDuringSignupFirestore.signUpWrite(
          loadingOn: loadingOn,
          loadingOff: loadingOff,
          emailaddess: emailAddressM,
          username: userNameM,
          dob: dobM,
          name: nameM,
          context: ctx);
      loadingOff();

      // ! change emailaddress to user emailaddress while deployment
      sendMail(username, "claw2020@gmail.com", generateFourDigitCode());

    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Flushbar(
        backgroundColor: Color(0xff121212),
        messageText: Text(
          message.toString(),
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      )..show(ctx);

      loadingOff();
    } catch (err) {
      print("Error : $err");
      if (err.toString().contains(
          "The email address is already in use by another account.")) {
        Flushbar(
          messageText: Text(
            "Email address exist",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else if (err.toString().contains(
          " The password is invalid or the user does not have a password.")) {
        Flushbar(
          messageText: Text(
            "Incorrect password",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else {
        Flushbar(
          messageText: Text(
            "Something went wrong try again",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      }
      loadingOff();
    }
  }

  static void loginUser(
      {@required TextEditingController emailAddress,
      @required TextEditingController password,
      @required Function loadingOn,
      @required Function loadingOff,
      @required BuildContext ctx}) async {
    final auth = FirebaseAuth.instance;
    UserCredential userResult;
    try {
      loadingOn();
      userResult = await auth.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
      loadingOff();
      print("User logged in...");

    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Flushbar(
        backgroundColor: Color(0xff121212),
        messageText: Text(
          message.toString(),
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      )..show(ctx);

      loadingOff();
    } catch (err) {
      print("Error : $err");
      if (err.toString().contains(
          "The email address is already in use by another account.")) {
        Flushbar(
          messageText: Text(
            "Email address exist",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else if (err.toString().contains(
          "The password is invalid or the user does not have a password.")) {
        Flushbar(
          messageText: Text(
            "Incorrect password",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else if (err.toString().contains(
          "There is no user record corresponding to this identifier. The user may have been deleted")) {
        Flushbar(
          messageText: Text(
            "Account does not exist create one",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else if (err.toString().contains(
          "The user account has been disabled by an administrator.")) {
        Flushbar(
          messageText: Text(
            "Account is disabled please visit our website",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else {
        Flushbar(
          messageText: Text(
            "Something went wrong try again",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      }
      loadingOff();
    }
  }

  static resetPassword(
      TextEditingController emailAddress, BuildContext context) async {
    final auth = FirebaseAuth.instance;
    UserCredential userResult;
    
    try {
      await auth.sendPasswordResetEmail(email: emailAddress.text);
      Flushbar(
        messageText: Text(
          "Check provided email address",
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
        backgroundColor: Color(0xff121212),
        duration: Duration(seconds: 3),
      )..show(context);
    } catch (error) {
      print(error.toString());
      if (error.toString().contains(
          "There is no user record corresponding to this identifier. The user may have been deleted")) {
        Flushbar(
          messageText: Text(
            "Cannot reset account does not exist",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
      } else {
        Flushbar(
          messageText: Text(
            "Something went wrong try again later",
            style: TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }
  }
}
