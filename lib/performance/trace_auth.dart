// Todo : Trace auth

import 'package:firebase_performance/firebase_performance.dart';

class TraceAuth {
  static void startTraceAuthLogin() {
    try {
      final Trace loginAuthTrace =
          FirebasePerformance.instance.newTrace("trace_auth");
      loginAuthTrace.start();
    } catch (error) {
      print("Error in tracing auth login : ${error.toString()}");
    }
  }

  static void stopTraceAuthLogin() {
    try {
      final Trace loginAuthTrace =
          FirebasePerformance.instance.newTrace("trace_auth");
      loginAuthTrace.stop();
    } catch (error) {
      print("Error in tracing auth login : ${error.toString()}");
    }
  }

  static void startTraceAuthSignup() {
    try {
      final Trace signUpAuthTrace =
          FirebasePerformance.instance.newTrace("trace_auth_signup");
      signUpAuthTrace.start();
    } catch (error) {
      print("Error in tracing auth signup : ${error.toString()}");
    }
  }

  static void stopTraceAuthSignup() {
    try {
      final Trace signUpAuthTrace =
          FirebasePerformance.instance.newTrace("trace_auth_signup");
      signUpAuthTrace.stop();
    } catch (error) {
      print("Error in tracing auth signup : ${error.toString()}");
    }
  }
}
