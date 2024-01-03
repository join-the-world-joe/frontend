import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/service/admin/progress/sign_in/sign_in_progress.dart';
import 'package:flutter_framework/common/service/admin/progress/sign_in/sign_in_step.dart';
import 'package:flutter_framework/common/service/admin/protocol/sign_in.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/utils/log.dart';
import 'screen.dart';
import 'package:flutter_framework/utils/navigate.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/validator/email.dart';
import '../config/config.dart';

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
  SignInProgress? signInProgress;

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
        message: 'responded',
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
      var rsp = SignInRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.passwordSignIn,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (signInProgress != null) {
        signInProgress!.respond(rsp);
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
    var caller = 'caller';
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
                          var behavior = 1; // email, by default
                          if (!isEmailValid(idControl.text)) {
                            behavior = 4;
                            var step = SignInStep.construct();
                            step.setBehavior(behavior);
                            step.setAccount(idControl.text);
                            step.setPassword(Runtime.rsa.encrypt(passwordControl.text));
                            signInProgress = SignInProgress.construct(
                              result: Code.internalError,
                              step: step,
                              message: Translator.translate(Language.tryingToSignIn),
                            );
                            signInProgress!.show(context: context).then((value) {
                              if (value == Code.oK) {
                                navigate(Screen.home);
                              } else {
                                showWarningDialog(context, Translator.translate(Language.operationTimeout));
                              }
                              signInProgress = null;
                            });
                            return;
                          }
                          if (signInProgress == null) {
                            var step = SignInStep.construct();
                            step.setBehavior(behavior);
                            step.setEmail(idControl.text);
                            step.setPassword(Runtime.rsa.encrypt(passwordControl.text));
                            signInProgress = SignInProgress.construct(
                              result: Code.internalError,
                              step: step,
                              message: Translator.translate(Language.tryingToSignIn),
                            );
                            signInProgress!.show(context: context).then((value) {
                              if (value == Code.oK) {
                                navigate(Screen.home);
                              } else {
                                showWarningDialog(context, Translator.translate(Language.operationTimeout));
                              }
                              signInProgress = null;
                            });
                          }
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
