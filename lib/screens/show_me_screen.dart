// @dart=2.9
import 'package:explore/data/all_secure_storage.dart' show writeRFATA;
import 'package:explore/serverless/firestore_signup.dart';
import '../serverless/match_making.dart';
import 'package:flutter/material.dart';
class ShowMeScreen extends StatefulWidget {
  @override
  _ShowMeScreenState createState() => _ShowMeScreenState();
}

class _ShowMeScreenState extends State<ShowMeScreen> {
  String selectedShowMe = "";
  int index = 0;
  void updateSelectedShowMe(int val) {
    // * 1 - men , 2 - women , 3 - everyone
    setState(() {
      index = val;
    });
  }

  @override
  // ? Check setstate disposed properly
  void setState(fn) {
    // ignore: todo
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff121212),
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "-Show me-",
                style: const TextStyle(
                    color: Color(0xffF8C80D),
                    fontSize: 20,
                    decoration: TextDecoration.none),
              )),
          Spacer(),
          Container(
            width: 250,
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Color(index == 1 ? 0xffF8C80D : 0xff121212),
              textColor: index == 1 ? Color(0xff121212) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0xffF8C80D), width: 2)),
              child: Text(
                "Men",
                style: const TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                selectedShowMe = "Men";
                print("Selected : $selectedShowMe");
                updateSelectedShowMe(1);
              },
            ),
          ),
          Container(
            width: 250,
            margin: const EdgeInsets.only(top: 20),
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Color(index == 2 ? 0xffF8C80D : 0xff121212),
              textColor: index == 2 ? Color(0xff121212) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0xffF8C80D), width: 2)),
              child: Text(
                "Women",
                style: const TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                selectedShowMe = "Women";
                print("Selected : $selectedShowMe");
                updateSelectedShowMe(2);
              },
            ),
          ),
          Container(
            width: 250,
            margin: const EdgeInsets.only(top: 20),
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Color(index == 3 ? 0xffF8C80D : 0xff121212),
              textColor: index == 3 ? Color(0xff121212) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0xffF8C80D), width: 2)),
              child: Text(
                "Everyone",
                style: const TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                selectedShowMe = "Everyone";
                print("Selected : $selectedShowMe");
                updateSelectedShowMe(3);
              },
            ),
          ),
          Spacer(),
          Container(
            width: 180,
            margin: const EdgeInsets.only(bottom: 20),
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Color(0xffF8C80D),
              textColor: Color(0xff121212),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Color(0xffF8C80D))),
              child: Text(
                "Confirm",
                style: const TextStyle(
                  fontSize: 20,
                  // fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: (){
                if (selectedShowMe.isNotEmpty){
                  MatchMakingCollection.addCurrentUserMM(selectedShowMe);
                  writeRFATA(selectedShowMe);
                  OnlyDuringSignupFirestore.updateShowMeFields(selectedShowMe,context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
