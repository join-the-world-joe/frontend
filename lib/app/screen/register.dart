import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/account.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/sms.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'dart:async';
import 'package:flutter_framework/common/service/account/business/register.dart';
import 'package:flutter_framework/common/service/sms/business/send_verification_code.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../../validator/mobile.dart';
import '../screen/screen.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/common/service/sms/protocol/send_verification_code.dart';
import 'package:flutter_framework/common/service/sms/business/send_verification_code.dart';
import 'package:flutter_framework/common/service/account/protocol/login.dart';
import 'package:flutter_framework/common/service/account/business/login.dart';
import 'package:flutter_framework/common/service/account/protocol/register.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Register> {
  final countryCodeControl = TextEditingController();
  final phoneNumberControl = TextEditingController();
  final verificationCodeControl = TextEditingController();
  late int countdown = 0;
  bool hasSentSMS = false;
  String smsButtonLabel = '获取';
  Timer? timer;
  double textFieldWidth = 310.0;


  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    print("Register.observe: major: $major, minor: $minor");
    try {
      if (major == Major.sms && minor == SMS.sendVerificationCodeRsp) {
        smsHandler(body);
      } else if (major == Major.account && minor == Account.registerRsp) {
        registerhandler(body);
      } else {
        print("Register.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Register.observe($major-$minor).e: ${e.toString()}');
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
        hasSentSMS = false;
        refresh();
        return;
      }
    } catch (e) {
      print("sms.send_verification_code.response failure, $e");
      return;
    }
  }

  void smsCallback(int code) {}

  void registerhandler(Map<String, dynamic> body) {
    try {
      RegisterRsp rsp = RegisterRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        showMessageDialog(context, '温馨提示：', '注册成功.')
            .then((value) => navigate(Screen.login));
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
      }
    } catch (e) {
      print("register.registerhandler failure, $e");
      return ;
    }
  }

  void refresh() {
    setState(() {});
  }

  void setup() {
    Runtime.setObserve(observe);
  }

  void navigate(String page) {
    print('Register.navigate to $page');

    Navigate.to(context, Screen.build(page));
  }

  @override
  void dispose() {
    print('Register.dispose');
    if (timer != null) {
      if (timer!.isActive) {
        print('Register.timer.cancel');
        timer!.cancel();
      }
    }
    super.dispose();
  }

  @override
  void initState() {
    print('Register.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var caller = 'build';
    return Builder(
      builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.cyan,
            title: const Text(
              '注册新用户',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                // Navigate.to(context, Screen.build(Screen.login));
                navigate(Screen.login);
              },
              icon: const Icon(Icons.chevron_left),
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
                        counterText: '',
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
                        // prefixIconConstraints:
                        //     BoxConstraints(minWidth: 0, minHeight: 0),
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
                                from: Screen.register,
                                caller: '$caller.sendVerificationCode',
                                behavior: Behavior.register,
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
                      onPressed: () async {
                        register(
                          verificationCode: verificationCodeControl.text,
                          countryCode: countryCodeControl.text,
                          phoneNumber: phoneNumberControl.text,
                        );
                      },
                      child: const Text(
                        '注册',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
