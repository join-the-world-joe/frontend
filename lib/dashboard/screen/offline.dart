import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/business/echo.dart';
import 'package:flutter_framework/dashboard/business/sign_in.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../setup.dart';
import '../../runtime/runtime.dart';
import '../screen/screen.dart';
import 'package:otp/otp.dart';

class Offline extends StatefulWidget {
  const Offline({Key? key, required this.lastScreen, required this.lastContent}) : super(key: key);

  final String lastScreen, lastContent;

  @override
  State createState() => _State();
}

class _State extends State<Offline> {
  bool closed = false;
  int curStage = 0;
  String message = const Uuid().v4();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      // print('Offline.yeildData.last: $lastStage, cur: ${curStage}');
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void echoHandler(Map<String, dynamic> body) {
    print('Offline.echoHandler');
    try {
      PongRsp rsp = PongRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        if (message.compareTo(rsp.getMessage()) == 0) {
          curStage++;
        }
        return;
      } else {
        curStage--;
        return;
      }
    } catch (e) {
      print("Offline.echoHandler failure, $e");
      curStage--;
      return;
    }
  }

  void signInHandler(Map<String, dynamic> body) {
    print('SMSSignIn.signInHandler');
    try {
      print('body: ${body.toString()}');
      SignInRsp rsp = SignInRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        print("SignInRsp: ${body.toString()}");
        // navigate(Screen.home);
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("SMSSignIn.signInHandler failure, $e");
      showMessageDialog(context, '温馨提示：', '未知错误');
      return;
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    try {
      // print("Offline.observe: major: $major, minor: $minor");
      if (major == Major.gateway && minor == Minor.gateway.pongRsp) {
        echoHandler(body);
      } else if (major == Major.backend && minor == Minor.backend.signInRsp) {
        signInHandler(body);
      } else {
        print("Offline.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Offline.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void refresh() {
    print('Offline.refresh');
    setState(() {});
  }

  void navigate(String page) {
    print('Offline.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void debug() {
    // {code: 0, user_id: 1, name: 流星, token: 7b775969-9baf-4659-86e9-f3c743b555fd, secret: BF6B6B677BCB7C5B}
    // {code: 0, user_id: 1, name: 流星, token: ab8f12c7-bc2b-4aff-b38f-8953a6e12fc8, secret: A5EABE66AHBADCA5}
    var userId = 1;
    var secret = 'BF6B6B677BCB7C5B';
    var token = '7b775969-9baf-4659-86e9-f3c743b555fd';
    Cache.setToken(token);
    Cache.setUserId(userId);
    Cache.setSecret(secret);
  }

  void setup() {
    print('Offline.setup');
    debug();
    setup_();
    Runtime.setObserve(observe);
  }

  @override
  void dispose() {
    print('Offline.dispose');
    super.dispose();
  }

  @override
  void initState() {
    print('Offline.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: StreamBuilder(
            stream: yeildData(),
            builder: (context, snap) {
              if (curStage > 1) {}
              return ListView(
                shrinkWrap: true,
                children: [
                  const Icon(
                    Icons.wifi_off,
                    size: 50,
                  ),
                  Spacing.addVerticalSpace(20),
                  const Center(
                    child: Text('网络连接已断开....'),
                  ),
                  Spacing.addVerticalSpace(20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 35),
                        foregroundColor: Colors.lightBlueAccent,
                        backgroundColor: Colors.lightBlueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        // navigate(Screen.passwordSignIn);
                        if (!Runtime.allow(major: int.parse(Major.gateway), minor: int.parse(Minor.gateway.pingReq))) {
                          return;
                        }
                        curStage = 0;
                        echo(message: message);
                        var code = OTP.generateTOTPCodeString(Cache.getSecret(), DateTime.now().millisecondsSinceEpoch, algorithm: Algorithm.SHA1, isGoogle: true);
                        Future.delayed(
                            Duration(milliseconds: 100),
                            () => signIn(
                                  email: '',
                                  token: Cache.getToken(),
                                  account: '',
                                  behavior: 3,
                                  password: Uint8List(0),
                                  phoneNumber: '',
                                  countryCode: '',
                                  verificationCode: int.parse(code),
                                  userId: Cache.getUserId(),
                                ));
                        // if (widget.lastContent.isNotEmpty) {
                        //   if (widget.lastContent == Screen.home && Cache.getMenuList().getLength() > 0 && Cache.getToken().isNotEmpty && Cache.getSecret().isNotEmpty) {
                        //     // signIn
                        //     signIn(
                        //       email: '',
                        //       token: Cache.getToken(),
                        //       account: '',
                        //       behavior: 3,
                        //       password: Uint8List(0),
                        //       phoneNumber: '',
                        //       countryCode: '',
                        //       verificationCode: OTP.generateTOTPCodeString(Cache.getSecret(), DateTime.now().millisecondsSinceEpoch).toString(),
                        //     );
                        //   }
                        // }
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '点击重连',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
