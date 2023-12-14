import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'screen.dart';
import 'package:flutter_framework/utils/navigate.dart';
import 'package:flutter_framework/common/business/sms/send_verification_code.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/validator/email.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/admin/sign_in.dart';
import 'package:flutter_framework/common/business//admin/sign_in.dart';

class PasswordSignIn extends StatefulWidget {
  const PasswordSignIn({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<PasswordSignIn> {
  bool closed = false;
  int curStage = 0;
  late int countdown = 0;
  final idControl = TextEditingController(text: 'admin@gmail.com');
  final passwordControl = TextEditingController(text: '123456');
  double widgetWidth = 450;
  Duration loginBusyDuration = const Duration(seconds: 10);

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('PasswordSignIn, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      } else {
        if (!Runtime.getConnectivity()) {
          curStage++;
          return;
        }
      }
    }
  }

  void navigate(String page) {
    if (!closed) {
      closed = true;
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          print('PasswordSignIn.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void observe(PacketClient packet) {
    var caller = 'observe';
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.passwordSignIn,
        caller: caller,
        message: '',
      );
      if (major == Major.admin && minor == Admin.signInRsp) {
        signInHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Screen.passwordSignIn,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.passwordSignIn,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void signInHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'signInHandler';
    try {
      SignInRsp rsp = SignInRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.passwordSignIn,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        Cache.setUserId(rsp.getUserId());
        Cache.setMemberId(rsp.getMemberId());
        Cache.setSecret(rsp.getSecret());
        navigate(Screen.home);
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
        return;
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.passwordSignIn,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void refresh() {
    // print('PasswordSignIn.refresh');
    setState(() {});
  }

  void setup() {
    // print('PasswordSignIn.setup');
    Runtime.setObserve(observe);
  }

  @override
  void dispose() {
    // print('PasswordSignIn.dispose');
    super.dispose();
  }

  @override
  void initState() {
    // print('PasswordSignIn.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: stream(),
          builder: (context, snap) {
            if (!Runtime.getConnectivity()) {
              navigate(Screen.offline);
              return const Text('');
            }
            return ListView(
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
                            major: int.parse(Major.admin),
                            minor: int.parse(Admin.signInReq),
                          )) {
                            return;
                          }
                          var behavior = 1; // email, by default
                          if (!isEmailValid(idControl.text)) {
                            behavior = 4;
                            signIn(
                              from: Screen.passwordSignIn,
                              behavior: behavior,
                              verificationCode: 0,
                              countryCode: '',
                              phoneNumber: '',
                              email: '',
                              account: idControl.text,
                              memberId: '',
                              password: Runtime.rsa.encrypt(passwordControl.text),
                              userId: 0,
                            );
                            refresh();
                            return;
                          }
                          signIn(
                            from: Screen.passwordSignIn,
                            behavior: behavior,
                            verificationCode: 0,
                            countryCode: '',
                            phoneNumber: '',
                            email: idControl.text,
                            account: '',
                            memberId: '',
                            password: Runtime.rsa.encrypt(passwordControl.text),
                            userId: 0,
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
            );
          },
        ),
      ),
    );
  }
}
