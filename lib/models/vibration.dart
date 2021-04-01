// @dart=2.9
import 'package:vibration/vibration.dart';

Future<void> vibrateStar() async {
  try {
    // *check if device has vibration
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 1000, amplitude: 128);
      print("Device vibrated");
    }
  } catch (error) {
    print("Error in vibrating starts : ${error.toString()}");
  }
}
