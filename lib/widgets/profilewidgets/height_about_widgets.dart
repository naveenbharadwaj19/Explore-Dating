// @dart=2.9
// todo : Height in about widget

import 'package:explore/serverless/profile_backend/abt_me_backend.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:numberpicker/numberpicker.dart';

Future heightPopUpBottomSheet(Color yellow,dynamic fetchedProfileData ,BuildContext context) {
  return showBarModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    builder: (context) => HeightPopUp(yellow,fetchedProfileData),
  );
}

class HeightPopUp extends StatefulWidget {
  final Color yellow;
  final dynamic fetchedProfileData;
  HeightPopUp(this.yellow,this.fetchedProfileData);
  @override
  _HeightPopUpState createState() => _HeightPopUpState();
}

class _HeightPopUpState extends State<HeightPopUp> {
  int selectedHeightValue = 150;

  String convertCmToFoot(int cm){
    double foot = cm / 30.48;
    String footStr = foot.toStringAsFixed(1);
    return footStr;
  }
  int convertFootToCm(String ftStr){
    double ftDouble = double.parse(ftStr);
    double ftToCm = ftDouble * 30.48;
    return ftToCm.round();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: 440,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "What's your height?",
              overflow: TextOverflow.fade,
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
            // ? number picker
            child: NumberPicker(
              value: selectedHeightValue,
              minValue: 94,
              maxValue: 220,
              textStyle: const TextStyle(color: Colors.white,fontSize: 20),
              selectedTextStyle: TextStyle(color: widget.yellow,fontSize: 20),
              itemHeight: 60,
              onChanged: (value){
                setState(() {
                  selectedHeightValue = value;
                });
              },
            ),
          ),
          const Divider(
            color: Colors.white54,
          ),
          Container(
            // ? selected height
            margin: const EdgeInsets.only(top:10,bottom: 10),
            child: Text("${convertCmToFoot(selectedHeightValue)} ft",style: const TextStyle(color: Colors.white70,fontSize: 18),),
          ),
          Container(
            // ? tip to skip the height -> empty str in database
            margin: const EdgeInsets.only(top:10,bottom: 10),
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
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
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
                    side: const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: (){
                    ProfileAboutMeBackEnd.height(convertCmToFoot(selectedHeightValue));
                    Navigator.pop(context);
                  },
                  onLongPress: (){
                    ProfileAboutMeBackEnd.height("");
                    print("height is skipped");
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