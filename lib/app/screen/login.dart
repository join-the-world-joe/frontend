import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/utils/navigate.dart';
import 'screen.dart';
import 'package:flutter_framework/common/business/sms/send_verification_code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/validator/mobile.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/business/account/login.dart';
import 'package:flutter_framework/framework/packet_client.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Login> {
  int lastStage = 0;
  int curStage = 1;
  late int countdown = 0;
  Timer? timer;
  double textFieldWidth = 310.0;
  bool hasSentSMS = false;
  String smsButtonLabel = '获取';
  final countryCodeControl = TextEditingController();
  final phoneNumberControl = TextEditingController();
  final verificationCodeControl = TextEditingController();

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    print("Login.observe: major: $major, minor: $minor");
    try {
      if (major == Major.sms && minor == Minor.sms.sendVerificationCodeRsp) {
        smsHandler(body);
      } else if (major == Major.account && minor == Minor.account.loginRsp) {
        loginHandler(body);
      } else {
        print("Login.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Login.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void smsHandler(Map<String, dynamic> body) {
    try {
      SendVerificationCodeRsp rsp = SendVerificationCodeRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
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
      } else if (rsp.getCode() == Code.invalidDataType) {
        showMessageDialog(context, '温馨提示：', '您输入的手机号不正确.');
        hasSentSMS = false;
        refresh();
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.getCode()}');
      }
    } catch (e) {
      print("Login.smsHandler failure, $e");
      return;
    }
  }

  void loginHandler(Map<String, dynamic> body) {
    try {
      var rsp = LoginRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print('token: ${rsp.token}');
        print('user_id: ${rsp.userId}');
        Runtime.setToken(rsp.token);
        navigate(Screen.home);
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
      }
      return;
    } catch (e) {
      print("Login.loginHandler failure, $e");
      return;
    }
  }

  void refresh() {
    setState(() {});
  }

  void setup() {
    Runtime.setObserve(observe);
  }

  void navigate(String page) {
    print('Login.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  @override
  void dispose() {
    print('Login.dispose');
    if (timer != null) {
      if (timer!.isActive) {
        print('Login.timer.cancel');
        timer!.cancel();
      }
    }
    super.dispose();
  }

  @override
  void initState() {
    print('Login.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.cyan,
            title: const Text(
              '验证码登录',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: textFieldWidth,
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
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
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
                      ),
                    ),
                  ),
                  Spacing.addVerticalSpace(20),
                  SizedBox(
                    width: textFieldWidth,
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
                                behavior: Behavior.login,
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
                  Spacing.addVerticalSpace(20),
                  SizedBox(
                    height: 40,
                    width: textFieldWidth,
                    child: ElevatedButton(
                      onPressed: () {
                        // navigate(Screen.home);
                        // Navigate.to(context, Screen.build(Screen.home));
                        login(
                          verificationCode: verificationCodeControl.text,
                          countryCode: countryCodeControl.text,
                          phoneNumber: phoneNumberControl.text,
                          token: '',
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
                  Spacing.addVerticalSpace(20),
                  Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: Text(
                        '访客?请点击注册',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25.0,
                        ),
                      ),
                      onTap: () {
                        // Navigate.to(context, Screen.build(Screen.register));
                        navigate(Screen.register);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
