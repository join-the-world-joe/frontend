import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
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

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    try {
      // print("User.observe: major: $major, minor: $minor");
      if (major == Major.gateway && minor == Minor.gateway.pongRsp) {
        echoHandler(body);
      } else {
        print("User.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('User.observe($major-$minor).e: ${e.toString()}');
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

  void setup() {
    print('Offline.setup');
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
                        if (widget.lastContent.isNotEmpty) {
                          if (widget.lastContent == Screen.home && Cache.getMenuList().getLength() > 0 && Cache.getToken().isNotEmpty) {
                            // signIn
                            signIn(
                              email: '',
                              token: Cache.getToken(),
                              account: '',
                              behavior: 3,
                              password: Uint8List(0),
                              phoneNumber: '',
                              countryCode: '',
                              verificationCode: '',
                            );
                          }
                        }
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
