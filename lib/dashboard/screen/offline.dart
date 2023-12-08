import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/echo.dart';
import 'package:flutter_framework/dashboard/business/fetch_rate_limiting_config.dart';
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
import '../config/config.dart';

class Offline extends StatefulWidget {
  const Offline({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Offline> {
  bool closed = false;
  int curStage = 0;
  String message = const Uuid().v4();

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      print('Offline, last: $lastStage, cur: $curStage');
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
          print('Offline.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
    }
  }

  void fetchRateLimitingConfigHandler(Map<String, dynamic> body) {
    print('Offline.fetchRateLimitingConfigHandler');
    try {
      FetchRateLimitingConfigRsp rsp = FetchRateLimitingConfigRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        Runtime.updateRateLimiter(rsp.getRateLimiter());
        curStage++;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.getCode()}');
        curStage--;
        return;
      }
      return;
    } catch (e) {
      print("Offline.fetchRateLimitingConfigHandler failure, $e");
      showMessageDialog(
        context,
        Translator.translate(Language.titleOfNotification),
        Translator.translate(Language.failureWithoutErrorCode),
      );
      curStage--;
      return;
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
    print('Offline.signInHandler');
    try {
      print('body: ${body.toString()}');
      SignInRsp rsp = SignInRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        // print("SignInRsp: ${body.toString()}");
        Cache.setUserId(rsp.getUserId());
        Cache.setMemberId(rsp.getMemberId());
        Cache.setSecret(rsp.getSecret());
        navigate(Screen.home);
        return;
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}${rsp.getCode()}',
        );
        return;
      }
    } catch (e) {
      print("Offline.signInHandler failure, $e");
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
      if (major == Major.backendGateway && minor == Minor.backendGateway.pongRsp) {
        echoHandler(body);
        Runtime.setConnectivity(true);
      } else if (major == Major.backendGateway && minor == Minor.backendGateway.fetchRateLimitingConfigRsp) {
        fetchRateLimitingConfigHandler(body);
      } else if (major == Major.admin && minor == Minor.admin.signInRsp) {
        Runtime.setConnectivity(true);
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
    // print('Offline.refresh');
    setState(() {});
  }

  void setup() {
    // print('Offline.setup');
    // debug();
    setup_();
    Runtime.setObserve(observe);
  }

  @override
  void dispose() {
    // print('Offline.dispose');
    super.dispose();
  }

  @override
  void initState() {
    // print('Offline.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: StreamBuilder(
            stream: stream(),
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
                  Center(
                    child: Text(Translator.translate(Language.networkDisconnected)),
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
                        print("secret: ${Cache.getSecret()}, memberId: ${Cache.getMemberId()}, userId: ${Cache.getUserId()}");

                        if (!Runtime.getConnectivity()) {
                          setup();
                        }

                        fetchRateLimitingConfig();

                        if (Runtime.allow(major: int.parse(Major.backendGateway), minor: int.parse(Minor.backendGateway.pingReq))) {
                          echo(message: message);
                        }

                        if (!Runtime.allow(major: int.parse(Major.admin), minor: int.parse(Minor.admin.signInReq))) {
                          return;
                        }

                        if (Cache.getMemberId().isNotEmpty && Cache.getSecret().isNotEmpty && Cache.getUserId() > 0) {
                          Future.delayed(
                            const Duration(milliseconds: 500),
                            () {
                              var totp = OTP.generateTOTPCodeString(Cache.getSecret(), DateTime.now().millisecondsSinceEpoch, algorithm: Algorithm.SHA1, isGoogle: true);
                              signIn(
                                userId: Cache.getUserId(),
                                email: '',
                                memberId: Cache.getMemberId(),
                                account: '',
                                behavior: 3,
                                password: Uint8List(0),
                                phoneNumber: '',
                                countryCode: '',
                                verificationCode: int.parse(totp),
                              );
                            },
                          );
                          return;
                        }
                        Future.delayed(
                          const Duration(milliseconds: 500),
                          () {
                            if (Runtime.getConnectivity()) {
                              navigate(Screen.smsSignIn);
                              return;
                            } else {
                              return;
                            }
                          },
                        );
                        return;
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
