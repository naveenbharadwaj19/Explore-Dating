// @dart=2.9
import 'package:vibration/vibration.dart';

Future<void> vibrate(int amplitude) async {
  try {
    // *check if device has vibration
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(amplitude: amplitude);
      print("Device vibrated");
    }
  } catch (error) {
    print("Error in vibrating starts : ${error.toString()}");
  }
}
