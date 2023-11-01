import 'package:flutter/cupertino.dart';
import 'loading.dart';
import 'register.dart';
import 'login.dart';
import 'home.dart';

class Screen {
  static const String login = 'Login';
  static const String register = 'Register';
  static const String home = 'Home';

  static Widget build(String screen) {
    switch (screen) {
      case login:
        {
          return const Login();
        }
      case register:
        {
          return const Register();
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
