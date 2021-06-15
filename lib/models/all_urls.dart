// @dart=2.9
// todo app urls expect url individual chat url

import 'package:url_launcher/url_launcher.dart';

Future<void> launchWeb()async{
    const url = "https://exploredating.in";
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "Cannot launch web";
    }
}

Future<void> launchFaq()async{
    const url = "https://exploredating.in/faq";
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "Cannot launch FAQ";
    }
}

Future<void> reportBug()async{
    const url = "https://forms.gle/quaooWZykX6LmTVS8";
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "Cannot launch reportBug";
    }
}

Future<void> launchTermsAndConditions()async{
    const url = "https://exploredating.in/terms_and_conditions";
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "Cannot launch t&c";
    }
}

Future<void> launchPhotoRules()async{
    const url = "https://exploredating.in/photo_rules";
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "Cannot launch photoRules";
    }
}

Future<void> launchPrivacyPolicy()async{
    const url = "https://exploredating.in/privacy_policy";
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "Cannot launch privacyPolicy";
    }
}