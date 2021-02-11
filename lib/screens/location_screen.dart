import 'package:explore/models/location.dart';
import 'package:explore/models/spinner.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LocationScreen extends StatefulWidget {
  static const routeName = "Location-screen";
  final Function updatedOpenCloseLocation;
  LocationScreen({this.updatedOpenCloseLocation});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool check = false;
  bool isLoading = false;
  final String _animationName = "SearchLocation";

  void changeToOpenSetting() {
    setState(() {
      check = true;
    });
  }

  void changeToAllowSettings() {
    setState(() {
      check = false;
    });
  }

  void loadingOn() {
    setState(() {
      isLoading = true;
    });
  }

  void loadingOff() {
    setState(() {
      isLoading = false;
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
    return Material(
      child: Container(
        color: Color(0xff121212),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 50),
              child: Text("-Location-",
                  style: TextStyle(color: Color(0xffF8C80D), fontSize: 25)),
            ),
            Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 40),
                  height: 300,
                  width: 300,
                  child: FlareActor(
                    "assets/animations/location_pin.flr",
                    fit: BoxFit.cover,
                    animation: _animationName,
                  ),
                ),
            Spacer(),
            isLoading
                ? loadingSpinner()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child : RaisedButton(
                        color: Color(0xffF8C80D),
                        textColor: Color(0xff121212),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Color(0xffF8C80D))),
                        child: Text(
                          // ! check permission spelling properly
                          check ? "Open settings" : "Allow permission",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              // fontFamily: "OpenSans",
                              fontSize: 18,
                              // fontWeight: FontWeight.w600,
                              ),
                        ),
                        onPressed: () {
                          LocationModel.checkPremission(
                              changeToOpenSetting: changeToOpenSetting,
                              changeToAllowSetting: changeToAllowSettings,
                              check: check,
                              loadingOn: loadingOn,
                              loadingOff: loadingOff,
                              updatedOpenCloseLocation: widget.updatedOpenCloseLocation,
                              context: context);
                        },
                      ),
                    ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                child: Text(
                  "Why ?",
                  style: TextStyle(
                      color: Color(0xffF8C80D),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline),
                ),
                onPressed: () => showMaterialModalBottomSheet(
                  // ? materialmodal bottom sheet package
                    backgroundColor: Theme.of(context).primaryColor,
                    context: context,
                    builder: (context) => Container(
                          height: 150,
                          child: Center(
                            child: Text(
                              // ! Use proper message before deployment
                              "We need location to find the best matches around you",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  // fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
