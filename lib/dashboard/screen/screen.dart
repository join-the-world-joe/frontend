import 'package:flutter/cupertino.dart';
import 'package:flutter_framework/dashboard/screen/offline.dart';
import 'loading.dart';
import 'password_sign_in.dart';
import 'home.dart';
import 'sms_sign_in.dart';

class Screen {
  static const String home = 'home';
  static const String smsSignIn = 'sms_sign_in';
  static const String passwordSignIn = 'password_sign_in';
  static const String offline = 'offline';
  static const String loading = 'loading';

  static Widget build(String screen) {
    switch (screen) {
      case loading: {
        return const Loading();
      }
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
      case offline:
        {
          return const Offline();
        }
      default:
        {
          return const Text('default');
        }
    }
  }
}
