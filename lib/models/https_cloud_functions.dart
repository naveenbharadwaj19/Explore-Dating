// @dart=2.9
// Todo : manage all https/http callable cloud functions
import 'package:cloud_functions/cloud_functions.dart';

Future<void> callUserDisableFunction() async{
  // ? when triggred user account is disabled 
    try{
    FirebaseFunctions disableFunction = FirebaseFunctions.instance;
    var callFunction = disableFunction.httpsCallable("disableUserAccount");
    await callFunction();
    print("disableUserAccount function is triggered");
    } catch (error){
      print("Error in https callable : ${error.toString()}");
    }
  }

Future<void> callUserDeleteFunction() async{
  // ? when triggred user account is deleted 
    try{
    FirebaseFunctions disableFunction = FirebaseFunctions.instance;
    var callFunction = disableFunction.httpsCallable("deleteUserAccount");
    await callFunction();
    print("deleteUserAccount function is triggered");
    } catch (error){
      print("Error in https callable : ${error.toString()}");
    }
  }