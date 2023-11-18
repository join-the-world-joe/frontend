import 'package:flutter/material.dart';
import 'package:flutter_framework/dashboard/component/test.dart';
import 'package:flutter_framework/dashboard/component/user.dart';
import 'package:flutter_framework/dashboard/screen/offline.dart';
import 'package:flutter_framework/dashboard/screen/password_sign_in.dart';
import 'package:flutter_framework/dashboard/screen/sms_sign_in.dart';
import 'screen/home.dart';
import 'screen/loading.dart';
import 'logic_test.dart';
import 'theme.dart';

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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        //     .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      initialRoute: '/offline',
      routes: {
        '/offline': (context) {
          return const Offline(
            lastScreen: '',
            lastContent: '',
          );
        },
        '/test': (context) {
          return Test();
        },
        '/logic_test': (context) {
          return LogicTest();
        },
        '/loading': (context) {
          return const Loading();
        },
        '/password_login': (context) {
          return const PasswordSignIn();
        },
        '/sms_sign_in': (context) {
          return const SMSSignIn();
        },
        '/home': (context) {
          return const Home();
        },
        '/user': (context) {
          return const User();
        },
      },
    );
  }
}
