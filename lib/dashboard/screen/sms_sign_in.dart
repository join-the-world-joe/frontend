import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/business/backend/sign_in.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'screen.dart';
import 'package:flutter_framework/utils/navigate.dart';
import 'package:flutter_framework/validator/mobile.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/business/sms/send_verification_code.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/routing.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';

class SMSSignIn extends StatefulWidget {
  const SMSSignIn({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<SMSSignIn> {
  late int countdown = 0;
  Timer? timer;
  bool hasSentSMS = false;
  String smsButtonLabel = '获取';
  final countryCodeControl = TextEditingController();
  final phoneNumberControl = TextEditingController();
  final verificationCodeControl = TextEditingController();

  void smsHandler(Map<String, dynamic> body) {
    try {
      SendVerificationCodeRsp rsp = SendVerificationCodeRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        // sent sms successfully
        countdown = 10;
        timer = Timer.periodic(
          const Duration(seconds: 1),
              (timer) {
            countdown--;
            // print('countdown: $countdown');
            smsButtonLabel = '$countdown';
            if (countdown <= 0) {
              timer.cancel();
              countdown = 0;
              hasSentSMS = false;
              smsButtonLabel = '获取';
            }
            refresh();
          },
        );
        return;
      } else if (rsp.code == Code.invalidDataType) {
        showMessageDialog(context, '温馨提示：', '您输入的手机号不正确.');
        hasSentSMS = false;
        refresh();
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("sms_sign_in.smsHandler failure, $e");
    }
  }

  void signInHandler(Map<String, dynamic> body) {
    try {
      SignInRsp rsp = SignInRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print('user_id: ${rsp.userId}');
        print('role: ${rsp.role}');
        print('token: ${rsp.token}');
        Cache.setRole(rsp.role);
        Cache.setToken(rsp.token);
        Cache.setUserId(rsp.userId);
        showMessageDialog(context, '温馨提示：', '成功')
            .then((value) => navigate(Screen.home));
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
        return;
      }
      return;
    } catch (e) {
      print("sms_sign_in.signInHandler failure, $e");
      return;
    }
  }

  void refresh() {
    setState(() {});
  }

  void navigate(String page) {
    print('navigate to $page');
    Runtime.hook.unRegister(
      Routing.key(major: Major.sms, minor: Minor.sms.sendVerificationCodeRsp),
    );
    Runtime.hook.unRegister(
      Routing.key(major: Major.backend, minor: Minor.backend.signInRsp),
    );

    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    Runtime.hook.register(
      Routing.key(major: Major.sms, minor: Minor.sms.sendVerificationCodeRsp),
      smsHandler,
    );
    Runtime.hook.register(
      Routing.key(major: Major.backend, minor: Minor.backend.signInRsp),
      signInHandler,
    );
  }

  @override
  void dispose() {
    print('sms_sign_in.dispose');
    if (timer != null) {
      if (timer!.isActive) {
        print('register.timer.cancel');
        timer!.cancel();
      }
    }
    super.dispose();
  }

  @override
  void initState() {
    setup();
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
                      navigate(Screen.passwordSignIn);
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '密码登录',
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
                    '验证码登录',
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
                    controller: verificationCodeControl,
                    style: const TextStyle(
                      fontSize: 30.0,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      LengthLimitingTextInputFormatter(4),
                    ],
                    maxLength: 4,
                    decoration: InputDecoration(
                      counterText: '',
                      isDense: true,
                      prefixIcon: const Text(
                        "验证码  ",
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(85, 35),
                            foregroundColor: hasSentSMS
                                ? Colors.grey
                                : Colors.lightBlueAccent,
                            backgroundColor: hasSentSMS
                                ? Colors.grey
                                : Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            smsButtonLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                            ),
                          ),
                          onPressed: () {
                            print('onPressed');
                            var countryCode = countryCodeControl.text;
                            var phoneNumber = phoneNumberControl.text;
                            if (isMobileValid(countryCode, phoneNumber) !=
                                Code.oK) {
                              showMessageDialog(
                                  context, '温馨提示：', '请输入正确的移动电话号码');
                              return;
                            }
                            if (hasSentSMS) {
                              return;
                            }
                            sendVerificationCode(
                              behavior: Behavior.signIn,
                              countryCode: countryCodeControl.text,
                              phoneNumber: phoneNumberControl.text,
                            );
                            hasSentSMS = true;
                            refresh();
                          },
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
                        verificationCode: verificationCodeControl.text,
                        countryCode: countryCodeControl.text,
                        phoneNumber: phoneNumberControl.text,
                        token: '',
                        password: Uint8List.fromList([]),
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
