import 'package:flutter/cupertino.dart';
import 'loading.dart';
import 'password_sign_in.dart';
import 'home.dart';
import 'sms_sign_in.dart';

class Screen {
  static const String home = 'home';
  static const String smsSignIn = 'sms_sign_in';
  static const String passwordSignIn = 'password_sign_in';

  static Widget build(String screen) {
    switch (screen) {
      case smsSignIn:
        {
          return const SMSSignIn();
        }
      case passwordSignIn:
        {
          return const PasswordSignIn();
        }
      case home:
        {
          return const Home();
        }
      default:
        {
          return const Text('default');
        }
    }
  }
}
