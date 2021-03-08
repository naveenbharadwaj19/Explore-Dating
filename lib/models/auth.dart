import 'package:explore/data/all_shared_pref_data.dart';
import 'package:explore/data/temp/auth_data.dart';
import 'package:explore/models/assign_errors.dart';
import 'package:explore/models/email_model.dart';
import '../serverless/firestore_signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/spinner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationFirebase {
  static void signInUser(
      {@required String emailAddress,
      @required String password,
      @required Function loadingOn,
      @required Function loadingOff,
      // @required String username,
      @required BuildContext ctx}) async {
    final auth = FirebaseAuth.instance;
    UserCredential userResult;

    try {
      loadingOn();
      userResult = await auth.createUserWithEmailAndPassword(
          email: emailAddress, password: password);
      await OnlyDuringSignupFirestore.signUpWrite(
          loadingOn: loadingOn,
          loadingOff: loadingOff,
          emailaddess: emailAddressM,
          // username: userNameM,
          dob: dobM,
          name: nameM,
          context: ctx);
      storeCurrentUserUid(userResult.user.uid);
      loadingOff();

      // ! change emailaddress to user emailaddress while deployment & when user kills the app and open the email verf
      // ! page and hit send code again username will be availabe as it was not in memory fix it
      sendMail("claw2020@gmail.com", generateFourDigitCode());
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Flushbar(
        backgroundColor: Color(0xff121212),
        messageText: Text(
          message.toString(),
          style: const TextStyle(
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
          messageText: const Text(
            "Email address exist",
            style: const TextStyle(

                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else if (err.toString().contains(
          " The password is invalid or the user does not have a password.")) {
        Flushbar(
          messageText: const Text(
            "Incorrect password",
            style: const TextStyle(

                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else {
        Flushbar(
          messageText: const Text(
            "Something went wrong try again",
            style: const TextStyle(

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
      DocumentReference updateIsLoggedin = FirebaseFirestore.instance.doc("Userstatus/${userResult.user.uid}");
      storeCurrentUserUid(userResult.user.uid);
      await updateIsLoggedin.update({
        "isloggedin" : true
      });
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
          style: const TextStyle(
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
          messageText: const Text(
            "Email address exist",
            style: const TextStyle(

                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else if (err.toString().contains(
          "The password is invalid or the user does not have a password.")) {
        Flushbar(
          messageText: const Text(
            "Incorrect password",
            style: const TextStyle(

                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else if (err.toString().contains(
          "There is no user record corresponding to this identifier. The user may have been deleted")) {
        Flushbar(
          messageText: const Text(
            "Account does not exist create one",
            style: const TextStyle(

                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else if (err.toString().contains(
          "The user account has been disabled by an administrator.")) {
        Flushbar(
          messageText: const Text(
            "Account is disabled",
            style: const TextStyle(

                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(ctx);
      } else {
        Flushbar(
          messageText: const Text(
            "Something went wrong try again",
            style: const TextStyle(

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
        messageText:const Text(
          "Check provided email address",
          style: const TextStyle(
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
          messageText: const Text(
            "Cannot reset account does not exist",
            style: const TextStyle(

                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
      } else {
        Flushbar(
          messageText: const Text(
            "Something went wrong try again later",
            style: const TextStyle(

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

class GoogleAuthenticationClass {
  // * Google auth
  static signinWithGoogle(Function loadingOnGoogle,Function loadingOffGoogle,BuildContext context) async {
    loadingOnGoogle();
    try {
      // * Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // * Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      
      // * Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //  * Once signed in, return the UserCredential
      UserCredential user = await FirebaseAuth.instance.signInWithCredential(credential);
      // print("display name : ${user.user.displayName} , emailaddress : ${user.user.email}");
      print("Using Google authentication");
      // * Pass the error : it will take some millisecond to create a user in firestore
      ErrorWidget.builder = ((e) {
        print("Bad document during google auth error suppressed");
          return Center(
          child: loadingSpinner(),
           );
          });
      // * Check for Uid exist in firestore
      DocumentSnapshot checkUserUid = await FirebaseFirestore.instance.doc("Users/${user.user.uid}").get();
      if(!checkUserUid.exists){
        // * no Uid exist so creating one
        print("No uid stored in firestore creating one...");
        await GooglePath.signInWithGoogle(context,user.user.displayName,user.user.email,user.user.uid);

      }
      storeCurrentUserUid(user.user.uid);
      DocumentReference updateLogin = FirebaseFirestore.instance.doc("Userstatus/${user.user.uid}");
      await updateLogin.update({
        "isloggedin" : true
      });
      
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains(
          "The user account has been disabled by an administrator.")) {
        Flushbar(
          messageText: const Text(
            "Account is disabled",
            style: const TextStyle(
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
      }else{
        Flushbar(
          messageText: Text(
            AssignErrors.expgogauth006,
            style: const TextStyle(
                color: Colors.white),
          ),
          backgroundColor: Color(0xff121212),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }
    loadingOffGoogle();
  }
}
