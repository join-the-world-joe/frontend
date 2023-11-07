import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class PasswordSignIn extends StatefulWidget {
  const PasswordSignIn({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<PasswordSignIn> {
  late int countdown = 0;
  final countryCodeControl = TextEditingController();
  final phoneNumberControl = TextEditingController();
  final passwordControl = TextEditingController();

  int signInHandler(Map<String, dynamic> body) {
    try {
      print('PasswordSignIn.signInHandler');
      SignInRsp rsp = SignInRsp.fromJson(body);
      if (rsp.code == Code.oK) {
      }
      return rsp.code;
    } catch (e) {
      print("sms_sign_in.signInHandler failure, $e");
      return Code.internalError;
    }
  }

  void signInCallback(int code) {
    print('PasswordSignIn.signInCallback');
    if (code == Code.oK) {
      showMessageDialog(context, '温馨提示：', '成功');
    } else {
      showMessageDialog(context, '温馨提示：', '未知错误  $code');
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
                      foregroundColor: Colors.lightBlue,
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      // Navigate.to(context, Screen.build(Screen.smsSignIn));
                      navigate(Screen.smsSignIn);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '验证码登录',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        // Icon(
                        //   Icons.vpn_key,
                        //   size: 25.0,
                        //   color: Colors.black,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(right: 5, top: 70),
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: Text(
                    '密码登录',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 27,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(right: 5, top: 10),
                child: SizedBox(
                  width: 350,
                  child: TextField(
                    controller: phoneNumberControl,
                    style: const TextStyle(
                      fontSize: 30.0,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration: InputDecoration(
                      // hintText: "号码",
                      hintText: '',
                      isDense: true,
                      prefixIcon: SizedBox(
                        width: 120,
                        child: TextField(
                          controller: countryCodeControl..text = '86',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            LengthLimitingTextInputFormatter(2),
                          ],
                          style: const TextStyle(
                            fontSize: 30.0,
                          ),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.add,
                              size: 25,
                              color: Colors.black,
                            ),
                            suffixIcon: Icon(
                              Icons.remove,
                              size: 25.0,
                              color: Colors.black,
                            ),
                            counterText: '',
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
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
                  width: 350,
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
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      signIn(
                        verificationCode: '',
                        countryCode: countryCodeControl.text,
                        phoneNumber: phoneNumberControl.text,
                        token: '',
                        password: Runtime.rsa.encrypt(passwordControl.text),
                      );
                    },
                    child: const Text(
                      '登录',
                      style: TextStyle(
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
