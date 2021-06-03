// @dart=2.9
// todo settings screen
import 'package:explore/server/handle_logout.dart';
import 'package:explore/server/https_cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';
import 'package:random_string/random_string.dart';

class SettingsScreen extends StatelessWidget {
  final String emailAddress = FirebaseAuth.instance.currentUser.email;
  final String currentLoginMethod =
      FirebaseAuth.instance.currentUser.providerData.first.providerId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black12, // status bar color
          statusBarIconBrightness: Brightness
              .light, // text brightness -> light for dark app -> vice versa
        ),
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 70,
        title: Container(
          margin: const EdgeInsets.only(top: 5),
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(children: [
              const TextSpan(
                text: "Explore\n",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
              const TextSpan(
                text: "Dating",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Domine",
                    decoration: TextDecoration.none),
              ),
            ]),
          ),
        ),
      ),
      body: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (context, packageSnapShot) {
          if (packageSnapShot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          return Column(
            children: [
              Container(
                // email address title
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 20, left: 60),
                child: Text(
                  "Email address",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).buttonColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                // email address
                width: double.infinity,
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 20, left: 60),
                child: Text(
                  emailAddress,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Container(
                // current login method title
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 20, left: 60),
                child: Text(
                  "Current login method",
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).buttonColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                // current login method title
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 20, left: 60),
                child: Text(
                  currentLoginMethod,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                // privacy policy button
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 30, left: 50),
                child: Container(
                  height: 60,
                  width: 160,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).buttonColor,
                    splashColor: Colors.white54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: Theme.of(context).buttonColor, width: 2)),
                    child: const Text(
                      "Privacy Policy",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      // todo navigate to website privacy policy
                    },
                  ),
                ),
              ),
              Container(
                // delete account button
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 25, left: 50),
                child: Container(
                  height: 60,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).buttonColor,
                    splashColor: Colors.red[600],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: Theme.of(context).buttonColor, width: 2)),
                    child: const Text(
                      "Delete Account",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () => _deleteAccountDialogueBox(context),
                  ),
                ),
              ),
              Container(
                // logout button
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 25, left: 50),
                child: Container(
                  height: 60,
                  width: 160,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).buttonColor,
                    splashColor: Colors.white54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: Theme.of(context).buttonColor, width: 2)),
                    child: const Text(
                      "Logout",
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () => logoutUser(context),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // made from love text
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // text
                          child: const Text(
                            "Made with",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                        Container(
                          // heart animation
                          margin: const EdgeInsets.only(left: 2),
                          child: Lottie.asset(
                            "assets/animations/heart_final.json",
                            fit: BoxFit.cover,
                            height: 40,
                            width: 40,
                          ),
                        ),
                        const Text(
                          "from India",
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  // app version
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    !packageSnapShot.hasData
                        ? ""
                        : "V ${packageSnapShot.data.version}",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

void _deleteAccountDialogueBox(BuildContext context) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final String randomString = randomAlphaNumeric(6);
  Widget confirm = Container(
    margin: const EdgeInsets.only(right: 15),
    // ignore: deprecated_member_use
    child: FlatButton(
      splashColor:
          Theme.of(context).buttonColor.withOpacity(0.8), // 80 % opacity
      child: const Text(
        "confirm",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () {
        if (formKey.currentState.validate()) {
          Navigator.pop(context);
          logoutUser(context);
          callUserDeleteFunction();
        }
      },
    ),
  );
  Widget cancel = Container(
    margin: const EdgeInsets.only(right: 15),
    // ignore: deprecated_member_use
    child: FlatButton(
      splashColor:
          Theme.of(context).buttonColor.withOpacity(0.8), // 80 % opacity
      child: const Text(
        "cancel",
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: () => Navigator.pop(context),
    ),
  );
  AlertDialog showAlert = AlertDialog(
    backgroundColor: Theme.of(context).primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      side: BorderSide(color: Theme.of(context).buttonColor, width: 2),
    ),
    title: Text(
      "Are you sure want to delete?",
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    content: Form(
      key: formKey,
      child: Container(
        // control column
        height: 170,
        child: Column(
          children: [
            Container(
              // undone message
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                "This action cannot be undone",
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Container(
              // random alpha numberic
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 5, bottom: 8),
              child: Text(
                "Type `$randomString` to confirm",
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            _ValidateDeleteForm(formKey, randomString),
          ],
        ),
      ),
    ),
    actions: [cancel, confirm],
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return showAlert;
      });
}

class _ValidateDeleteForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String randomString;
  _ValidateDeleteForm(this.formKey, this.randomString);
  @override
  _ValidateDeleteFormState createState() => _ValidateDeleteFormState();
}

class _ValidateDeleteFormState extends State<_ValidateDeleteForm> {
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: TextFormField(
        controller: _controller,
        enabled: true,
        cursorColor: Colors.white,
        cursorWidth: 3.0,
        maxLines: 1,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).buttonColor.withOpacity(0.8),
                  width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).buttonColor, width: 2),
            ),
            hintText: "Type here...",
            hintStyle: const TextStyle(
                color: Colors.white54, fontWeight: FontWeight.w700),
            errorMaxLines: 1,
            errorStyle: const TextStyle(fontSize: 16)),
        validator: (String value) {
          if (value.length > 6) {
            return "More than 6 characters";
          } else if (value.isEmpty || value != widget.randomString) {
            return "Characters does not match";
          }
          return null;
        },
      ),
    );
  }
}
