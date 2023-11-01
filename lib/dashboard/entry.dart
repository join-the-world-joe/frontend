import 'package:flutter/material.dart';
import 'package:flutter_framework/dashboard/screen/password_sign_in.dart';
import 'package:flutter_framework/dashboard/screen/sms_sign_in.dart';
import 'screen/home.dart';
import 'screen/loading.dart';
import 'logic_test.dart';

class Entry extends StatefulWidget {
  const Entry({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading',
      routes: {
        '/logic_test': (context) {
          return  LogicTest();
        },
        '/loading': (context) {
          return const Loading();
        },
        '/password_login': (context) {
          return const PasswordSignIn();
        },
        '/sms_login': (context) {
          return const SMSSignIn();
        },
        '/home': (context) {
          return const Home();
        },
      },
    );
  }
}
