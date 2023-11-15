import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'screen.dart';
import 'package:flutter_framework/utils/navigate.dart';
import 'package:flutter_framework/common/business/sms/send_verification_code.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/dashboard/business/sign_in.dart';
import 'package:flutter_framework/validator/email.dart';

class PasswordSignIn extends StatefulWidget {
  const PasswordSignIn({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<PasswordSignIn> {
  late int countdown = 0;
  final idControl = TextEditingController(text: 'xx@gmail.com');
  final passwordControl = TextEditingController(text: '123456');
  double widgetWidth = 450;
  Duration loginBusyDuration = const Duration(seconds: 10);

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    print("PasswordSignIn.observe: major: $major, minor: $minor");
    try {
      if (major == Major.backend && minor == Minor.backend.signInRsp) {
        signInHandler(body);
      } else {
        print("PasswordSignIn.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('PasswordSignIn.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void signInHandler(Map<String, dynamic> body) {
    print('PasswordSignIn.signInHandler');
    try {
      SignInRsp rsp = SignInRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        navigate(Screen.home);
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.code}');
        return;
      }
      return;
    } catch (e) {
      print("PasswordSignIn.signInHandler failure, $e");
      showMessageDialog(context, '温馨提示：', '未知错误');
      return;
    }
  }

  void navigate(String page) {
    print('PasswordSignIn.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void refresh() {
    print('PasswordSignIn.refresh');
    setState(() {});
  }

  void setup() {
    print('PasswordSignIn.setup');
    Runtime.setObserve(observe);
  }

  void progress() async {
    print('PasswordSignIn.progress');
    return;
  }

  @override
  void dispose() {
    print('PasswordSignIn.dispose');
    super.dispose();
  }

  @override
  void initState() {
    print('PasswordSignIn.initState');
    setup();
    progress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 30, top: 70),
                child: SizedBox(
                  width: 150,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(85, 35),
                      foregroundColor: Colors.lightBlueAccent,
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      navigate(Screen.smsSignIn);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '验证码登录',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 70),
                child: SizedBox(
                  width: widgetWidth,
                  height: 50,
                  child: const Text(
                    '密码登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 20),
                child: SizedBox(
                  width: widgetWidth,
                  child: TextField(
                    obscureText: false,
                    controller: idControl,
                    style: const TextStyle(
                      fontSize: 30.0,
                    ),
                    inputFormatters: [
                      // FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: const InputDecoration(
                      counterText: '',
                      isDense: true,
                      prefixIcon: Text(
                        "帐号  ",
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 20),
                child: SizedBox(
                  width: widgetWidth,
                  child: TextField(
                    obscureText: true,
                    controller: passwordControl,
                    style: const TextStyle(
                      fontSize: 30.0,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(20),
                    ],
                    decoration: const InputDecoration(
                      counterText: '',
                      isDense: true,
                      prefixIcon: Text(
                        "密码  ",
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 20),
                child: SizedBox(
                  height: 40,
                  width: widgetWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!Runtime.allow(
                        major: int.parse(Major.backend),
                        minor: int.parse(Minor.backend.signInReq),
                      )) {
                        return;
                      }
                      var behavior = 1; // email, by default
                      if (!isEmailValid(idControl.text)) {
                        behavior = 4;
                        signIn(
                          behavior: behavior,
                          verificationCode: '',
                          countryCode: '',
                          phoneNumber: '',
                          email: '',
                          account: idControl.text,
                          token: '',
                          password: Runtime.rsa.encrypt(passwordControl.text),
                        );
                        refresh();
                        return;
                      }
                      signIn(
                        behavior: behavior,
                        verificationCode: '',
                        countryCode: '',
                        phoneNumber: '',
                        email: idControl.text,
                        account: '',
                        token: '',
                        password: Runtime.rsa.encrypt(passwordControl.text),
                      );
                      refresh();
                      return;
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(85, 35),
                      foregroundColor: Colors.lightBlueAccent,
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text(
                      '登录',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
