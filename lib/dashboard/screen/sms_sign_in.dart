import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'screen.dart';
import 'package:flutter_framework/utils/navigate.dart';
import 'package:flutter_framework/validator/mobile.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/business/sms/send_verification_code.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/dashboard/business/sign_in.dart';

class SMSSignIn extends StatefulWidget {
  const SMSSignIn({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<SMSSignIn> {
  bool closed = false;
  int curStage = 0;
  late int countdown = 0;
  Timer? countdownTimer;
  bool fSent = false;
  String smsButtonLabel = '获取';
  Duration loginBusyDuration = const Duration(seconds: 10);
  final countryCodeControl = TextEditingController();
  final phoneNumberControl = TextEditingController(text: '18629309942');
  final verificationCodeControl = TextEditingController(text: '1111');

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(const Duration(milliseconds: 100));
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
          print('SMSSignIn.navigate to $page');
          if (countdownTimer != null) {
            if (countdownTimer!.isActive) {
              print('SMSSignIn.countdownTimer.cancel');
              countdownTimer!.cancel();
            }
          }
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    print("SMSSignIn.observe: major: $major, minor: $minor");
    try {
      if (major == Major.sms && minor == Minor.sms.sendVerificationCodeRsp) {
        smsHandler(body);
      } else if (major == Major.admin && minor == Minor.admin.signInRsp) {
        signInHandler(body);
      } else {
        print("SMSSignIn.observe warning: $major-$minor doesn't matched");
      }
    } catch (e) {
      print('SMSSignIn.observe failure($major-$minor), e: ${e.toString()}');
    } finally {}
  }

  void smsHandler(Map<String, dynamic> body) {
    print('SMSSignIn.smsHandler');
    try {
      SendVerificationCodeRsp rsp = SendVerificationCodeRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        // sent sms successfully
        countdown = 60;
        countdownTimer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) {
            countdown--;
            // print('countdown: $countdown');
            smsButtonLabel = '$countdown';
            if (countdown <= 0) {
              timer.cancel();
              countdown = 0;
              fSent = false;
              smsButtonLabel = '获取';
            }
            refresh();
          },
        );
        return;
      } else if (rsp.code == Code.invalidDataType) {
        showMessageDialog(context, '温馨提示：', '您输入的手机号不正确.');
        fSent = false;
        refresh();
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("SMSSignIn.smsHandler failure, $e");
    }
  }

  void signInHandler(Map<String, dynamic> body) {
    try {
      SignInRsp rsp = SignInRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        Cache.setUserId(rsp.getUserId());
        Cache.setMemberId(rsp.getMemberId());
        Cache.setSecret(rsp.getSecret());
        navigate(Screen.home);
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.getCode()}');
        return;
      }
    } catch (e) {
      print("SMSSignIn.signInHandler failure, $e");
      showMessageDialog(context, '温馨提示：', '未知错误');
      return;
    } finally {}
  }

  void refresh() {
    // print('SMSSignIn.refresh');
    setState(() {});
  }

  void setup() {
    // print('SMSSignIn.setup');
    Runtime.setObserve(observe);
  }

  @override
  void dispose() {
    // print('SMSSignIn.dispose');
    super.dispose();
  }

  @override
  void initState() {
    // print('SMSSignIn.initState');
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
                          navigate(Screen.passwordSignIn);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '密码登录',
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
                                  color: Colors.white,
                                ),
                                suffixIcon: Icon(
                                  Icons.remove,
                                  size: 25.0,
                                  color: Colors.white,
                                ),
                                counterText: '',
                                isDense: true,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(85, 35),
                                foregroundColor: fSent ? Colors.grey : Colors.lightBlueAccent,
                                backgroundColor: fSent ? Colors.grey : Colors.lightBlueAccent,
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
                                if (isMobileValid(countryCode, phoneNumber) != Code.oK) {
                                  showMessageDialog(context, '温馨提示：', '请输入正确的移动电话号码');
                                  return;
                                }
                                if (fSent) {
                                  return;
                                }
                                sendVerificationCode(
                                  behavior: Behavior.signIn,
                                  countryCode: countryCodeControl.text,
                                  phoneNumber: phoneNumberControl.text,
                                );
                                fSent = true;
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
                          if (!Runtime.allow(
                            major: int.parse(Major.admin),
                            minor: int.parse(Minor.admin.signInReq),
                          )) {
                            return;
                          }
                          signIn(
                            behavior: 2,
                            verificationCode: int.parse(verificationCodeControl.text),
                            countryCode: countryCodeControl.text,
                            phoneNumber: phoneNumberControl.text,
                            email: '',
                            account: '',
                            memberId: '',
                            password: Uint8List.fromList([]),
                            userId: 0,
                          );
                          refresh();
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
