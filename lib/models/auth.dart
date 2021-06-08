// @dart=2.9
import 'package:explore/models/all_enums.dart';
import 'package:explore/models/assign_errors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/models/spinner.dart';
import 'package:explore/server/signup_process.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication {
  //  Google auth
  static signinWithGoogle(Function loadingOnGoogle, Function loadingOffGoogle,
      BuildContext context) async {
    loadingOnGoogle();
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //  Once signed in, return the UserCredential
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // print("display name : ${user.user.displayName} , emailaddress : ${user.user.email}");
      print("Via Google authentication");
      //  supress the error : it will take some millisecond to create a user in firestore
      ErrorWidget.builder = ((e) {
        print("Bad document during google auth error suppressed");
        return Center(
          child: loadingSpinner(),
        );
      });
      //  Check if used data exists
      DocumentSnapshot checkUserUid =
          await FirebaseFirestore.instance.doc("Users/${user.user.uid}").get();
      if (!checkUserUid.exists) {
        // no Uid exist so creating one
        print("No user found so creating one...");
        await createUserData(AuthenticationType.google, context,
            user.user.displayName, user.user.email, user.user.uid);
      } else if (checkUserUid.exists) {
        DocumentReference updateLogin =
            FirebaseFirestore.instance.doc("Users/${user.user.uid}");
        await updateLogin.update({"is_loggedin": true});
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        messageText: Text(
          message.toString(),
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
        ),
        duration: Duration(seconds: 3),
      )..show(context);

      loadingOffGoogle();
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains(
          "The user account has been disabled by an administrator.")) {
        Flushbar(
          messageText: const Text(
            "Account is suspended",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
        )..show(context);
      } else if (error.toString().contains(
          "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.")) {
        Flushbar(
          messageText: const Text(
            "Email address exist",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
        )..show(context);
      } else if (error
          .toString()
          .contains("The getter 'authentication' was called on null.")) {
        print("Google token called null.Can ignore this message...");
      } else {
        Flushbar(
          messageText: Text(
            AssignErrors.edpgogauth006,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }
    loadingOffGoogle();
  }
}

class FacebookAuthentication {
  static Future signinFacebook(
      Function loadingOnFb, Function loadingOffFb, BuildContext context) async {
    loadingOnFb();
    try {
      final LoginResult fbResult = await FacebookAuth.instance.login();
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(fbResult.accessToken.token);
      final List<String> allowedPermissions = fbResult
          .accessToken.grantedPermissions; // permissions allowed by the user
      if (!allowedPermissions.contains("email")) {
        // check if email permisssion is not granted
        print("Some permissions are denied by the user Fb");
        Flushbar(
          messageText: const Text(
            "Some permissions are missing please allow them",
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
        )..show(context);
      } else {
        // permissions are granted
        // Once signed in, return the UserCredential
        final UserCredential user = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        print("Via Facebook authentication");
        //  suppress the error : it will take some millisecond to create a user in firestore
        ErrorWidget.builder = ((e) {
          print("Bad document during fb auth error suppressed");
          return Center(
            child: loadingSpinner(),
          );
        });
        //  Check if used data exists
        DocumentSnapshot checkUserUid = await FirebaseFirestore.instance
            .doc("Users/${user.user.uid}")
            .get();
        if (!checkUserUid.exists) {
          // no Uid exist so creating one
          print("No user found so creating one...");
          await createUserData(AuthenticationType.facebook, context,
              user.user.displayName, user.user.email, user.user.uid);
        } else if (checkUserUid.exists) {
          DocumentReference updateLogin =
              FirebaseFirestore.instance.doc("Users/${user.user.uid}");
          await updateLogin.update({"is_loggedin": true});
        }
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }
      Flushbar(
        backgroundColor: Theme.of(context).primaryColor,
        messageText: Text(
          message.toString(),
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: const TextStyle(
              fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
        ),
        duration: Duration(seconds: 3),
      )..show(context);

      loadingOffFb();
    } catch (error) {
      print("Error : ${error.toString()}");
      if (error.toString().contains(
          "The user account has been disabled by an administrator.")) {
        Flushbar(
          messageText: const Text(
            "Account is suspended",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
        )..show(context);
      } else if (error.toString().contains(
          "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.")) {
        Flushbar(
          messageText: const Text(
            "Email address exist",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
        )..show(context);
      } else if (error
          .toString()
          .contains("The getter 'token' was called on null.")) {
        print("Fb token called null.Can ignore this message...");
      } else {
        Flushbar(
          messageText: Text(
            AssignErrors.edfbauth007,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }
    loadingOffFb();
  }
}
