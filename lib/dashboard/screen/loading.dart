import 'package:flutter/material.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import '../setup.dart';
import 'sms_sign_in.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Loading> {
  int lastStage = 0;
  int curStage = 0;

  void refresh() {
    setState(() {});
  }

  void setup() {
    setup_();
  }

  void progress() async {
    setup_();
    await Future.delayed(const Duration(milliseconds: 500));
    curStage = 1;
    refresh();
    return;
  }

  void callback(int code) {
    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setup();
    progress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (curStage == 0) {
          return const Center(child: CircularProgressIndicator());
        } else if (curStage == 1) {
          lastStage = curStage;
          // print('curStage == 1');
          Navigate.pushReplacement(context, Screen.build(Screen.smsSignIn));
          return const Text('');
        } else if (curStage == 2) {
          lastStage = curStage;
          // print('curStage == 2');
          return const Text('auth done');
        } else {
          return const Text('else case');
        }
      },
    );
  }
}
