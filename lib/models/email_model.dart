import 'package:Explore/data/auth_data.dart';
import 'package:mailgun/mailgun.dart';
import 'package:random_string/random_string.dart';

String generateFourDigitCode(){
  String fourDigits = randomNumeric(4);
  return fourDigits;
}



void sendMail(String userName,String toEmailAddress, String fourDigitCode) async {
  String domainName = "sandboxbced68cb03464b91bd7ddbc865c74279.mailgun.org";
  String apiKey = "c4b0231a96b32fedf9fc1c493813f8ea-95f6ca46-a779764f";
  print("FourDigitCode : $fourDigitCode");
  storeGeneratedCode = fourDigitCode;
  var mailGun = MailgunMailer(domain: domainName, apiKey: apiKey);
  var response = await mailGun.send(
    from: "Team Explore expexplore20@gmail.com",
    to: [toEmailAddress],
    subject: "E -Verify email address",
    template: "email",
    options: {
      "template_variables": {
        "username": userName,
        "fourdigitcode": "${fourDigitCode[0]} ${fourDigitCode[1]} ${fourDigitCode[2]} ${fourDigitCode[3]}",
      },
    },
  );

  if (response.status.toString() == "SendResponseStatus.QUEUED" ||
      response.status.toString() == "SendResponseStatus.OK") {
    print("Successfull");
    print(response.status.toString());
  } else {
    print(response.status.toString());
    print(response.message);
  }
}
