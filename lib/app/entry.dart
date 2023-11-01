import 'package:flutter/material.dart';
import 'template.dart';
import 'builder_template.dart';
import 'future_builder_template.dart';
import 'screen/loading.dart';
import 'screen/register.dart';
import 'screen/login.dart';
import 'screen/home.dart';
import 'package:flutter_framework/framework/framework_test.dart';

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
        '/login': (context) {
          return const Login();
        },
        '/framework': (context) {
          return const FrameworkTest();
        },
        '/register': (context) {
          return const Register();
        },
        '/loading': (context) {
          return const Loading();
        },
        '/home': (context) {
          return const Home();
        },
      },
    );
  }
}
