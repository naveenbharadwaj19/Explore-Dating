// @dart=2.9
// todo from about widgets
import 'package:csc_picker/csc_picker.dart';
import 'package:explore/serverless/profile_backend/abt_me_backend.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future fromPopUpBottomSheet(BuildContext context, Color yellow) {
  return showBarModalBottomSheet(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    builder: (context) => FromPopUp(yellow),
  );
}

class FromPopUp extends StatefulWidget {
  final Color yellow;
  FromPopUp(this.yellow);
  @override
  _FromPopUpState createState() => _FromPopUpState();
}

class _FromPopUpState extends State<FromPopUp> {
  String country = "";
  String state = "";
  String city = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 330,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Where you from?",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: CSCPicker(
              selectedItemStyle: const TextStyle(fontSize: 18),
              dropdownDecoration: const BoxDecoration(color: Colors.white),
              disabledDropdownDecoration:
                  const BoxDecoration(color: Colors.white54),
              onCountryChanged: (value) {
                print(value);
                setState(() {
                  country = value;
                });
              },
              onStateChanged: (value) {
                print(value);
                setState(() {
                  state = value;
                });
              },
              onCityChanged: (value) {
                print(value);
                setState(() {
                  city = value;
                });
              },
            ),
          ),
          Container(
            // ? tip to skip the height -> empty str in database
            margin: const EdgeInsets.only(top:15,bottom: 10),
            child: const Text("Hint : Long press save to skip",style: const TextStyle(color: Colors.white70,fontSize: 18),),
          ),
          const Spacer(),
          Row(
            // ? later and save button
            children: [
              Container(
                // ? later button
                margin: const EdgeInsets.only(left: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side:
                        const BorderSide(color: Color(0xffF8C80D), width: 1.5),
                  ),
                  child: const Text(
                    "Later",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Container(
                // ? vertical divder
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                height: 30,
                width: 3,
                color: Colors.white54,
              ),
              const Spacer(),
              Container(
                // ? save button
                margin: const EdgeInsets.only(right: 30, bottom: 20),
                width: 150,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Color(0xff121212),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side:
                        const BorderSide(color: Color(0xffF8C80D), width: 1.5),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if (country.isNotEmpty &&
                        state.isNotEmpty &&
                        city.isNotEmpty) {
                      ProfileAboutMeBackEnd.from("$country", "$state,", "$city,");
                    }
                    Navigator.pop(context);
                  },
                  onLongPress: (){
                     ProfileAboutMeBackEnd.from("", "", "");
                     print("From skipped");
                     Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
