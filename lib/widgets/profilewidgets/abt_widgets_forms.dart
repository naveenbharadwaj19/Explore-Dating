// @dart=2.9
// todo : All pop up textform of modal sheet

import 'package:explore/server/profile_backend/abt_me_backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future aboutMePopUpBottomSheet(BuildContext context, Color yellow,String aboutMeData) {
  final TextEditingController aboutMeController = TextEditingController(text: aboutMeData);
  return showBarModalBottomSheet(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    builder: (context) => AboutMePopUp(yellow,aboutMeController),
  );
}

class AboutMePopUp extends StatefulWidget {
  final Color yellow;
  final TextEditingController aboutMeController;
  AboutMePopUp(this.yellow,this.aboutMeController);
  @override
  _AboutMePopUpState createState() => _AboutMePopUpState();
}

class _AboutMePopUpState extends State<AboutMePopUp> {
  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    widget.aboutMeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardVisible = MediaQuery.of(context).viewInsets.bottom;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).primaryColor,
      height: keyboardVisible == 0.0 ? 400 : height - 50,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Say something about yourself",
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
          Expanded(
            child: Align(
              alignment: Alignment(-0.3, 0.0),
              child: Container(
                width: 300,
                // ! Need to use mediaquery to fix the width to avoid pixel overflow
                margin: const EdgeInsets.only(top: 30, left: 20),
                child: Container(
                  child: TextField(
                    controller: widget.aboutMeController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          300), // max characters 300
                    ],
                    textCapitalization: TextCapitalization.sentences,
                    enabled: true,
                    minLines: 1,
                    maxLines: null,
                    cursorColor: Colors.white,
                    cursorWidth: 3.0,
                    // ! Need to use input text as WORDSANS
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: widget.yellow, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: widget.yellow, width: 2),
                      ),
                      hintText: "About yourself",
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
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
                  onPressed: () {
                    Navigator.pop(context);
                    widget.aboutMeController.clear();
                  },
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
                  onPressed: (){
                    if(widget.aboutMeController.text.isNotEmpty){
                      ProfileAboutMeBackEnd.aboutMe(widget.aboutMeController.text.trim());
                    }
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

Future workTitlePopupBottomSheet(BuildContext context, Color yellow) {
  return showBarModalBottomSheet(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    builder: (context) => WorkTitlePopUp(yellow),
  );
}

class WorkTitlePopUp extends StatefulWidget {
  final Color yellow;
  WorkTitlePopUp(this.yellow);
  @override
  _WorkTitlePopUpState createState() => _WorkTitlePopUpState();
}

class _WorkTitlePopUpState extends State<WorkTitlePopUp> {
  final TextEditingController workTitleController = TextEditingController();

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    workTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardVisible = MediaQuery.of(context).viewInsets.bottom;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).primaryColor,
      height: keyboardVisible == 0.0 ? 300 : height - 50,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Work",
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
          Align(
            alignment: Alignment(-0.3, 0.0),
            child: Container(
              height: 60,
              width: 300,
              // ! Need to use mediaquery to fix the width to avoid pixel overflow
              margin: const EdgeInsets.only(top: 30, left: 20),
              child: TextField(
                controller: workTitleController,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                ],
                textCapitalization: TextCapitalization.words,
                enabled: true,
                cursorColor: Colors.white,
                cursorWidth: 3.0,
                // ! Need to use input text as WORDSANS
                style: const TextStyle(color: Colors.white, fontSize: 18),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: widget.yellow,width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: widget.yellow,width: 2),
                  ),
                  hintText: "Enter your work",
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w700),
                ),
              ),
            ),
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
                  onPressed: () {
                    Navigator.pop(context);
                    workTitleController.clear();
                  },
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
                        const BorderSide(color: Color(0xffF8C80D), width: 2),
                  ),
                  child: const Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: () {
                    if(workTitleController.text.isNotEmpty){
                      ProfileAboutMeBackEnd.work(workTitleController.text);
                    }
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


Future educationPopUpBottomSheet(BuildContext context, Color yellow) {
  return showBarModalBottomSheet(
    backgroundColor: Theme.of(context).primaryColor,
    context: context,
    builder: (context) => EducationPopUp(yellow),
  );
}

class EducationPopUp extends StatefulWidget {
  final Color yellow;
  EducationPopUp(this.yellow);
  @override
  _EducationPopUpState createState() => _EducationPopUpState();
}

class _EducationPopUpState extends State<EducationPopUp> {
  final TextEditingController educationController  = TextEditingController();

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    educationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardVisible = MediaQuery.of(context).viewInsets.bottom;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).primaryColor,
      height: keyboardVisible == 0.0 ? 300 : height - 50,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Where do you study?",
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
          Align(
            alignment: Alignment(-0.3, 0.0),
            child: Container(
              height: 60,
              width: 300,
              // ! Need to use mediaquery to fix the width to avoid pixel overflow
              margin: const EdgeInsets.only(top: 30, left: 20),
              child: TextField(
                controller: educationController,
                maxLines: 1,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(25),
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                ],
                textCapitalization: TextCapitalization.words,
                enabled: true,
                cursorColor: Colors.white,
                cursorWidth: 3.0,
                // ! Need to use input text as WORDSANS
                style: const TextStyle(color: Colors.white, fontSize: 18),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: widget.yellow,width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: widget.yellow,width: 2),
                  ),
                  hintText: "I study at",
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w700),
                ),
              ),
            ),
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
                  onPressed: () {
                    Navigator.pop(context);
                    educationController.clear();
                  },
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
                    if(educationController.text.isNotEmpty){
                      ProfileAboutMeBackEnd.education(educationController.text);
                    }
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
