import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/business/echo.dart';
import 'package:flutter_framework/dashboard/business/fetch_rate_limiting_config.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import '../setup.dart';
import 'package:uuid/uuid.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State createState() => _State();
}

class _State extends State<Loading> {
  int curStage = 0;
  bool closed = false;
  String message = const Uuid().v4();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      // print('showMenuListOfUserDialog.last: $lastStage, showMenuListOfUserDialog.cur: ${curStage}');
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        // print('showRoleListOfUserDialog.last: $lastStage');
        yield lastStage;
      }
    }
  }

  void echoHandler(Map<String, dynamic> body) {
    print('Loading.echoHandler');
    try {
      PongRsp rsp = PongRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        if (message.compareTo(rsp.getMessage()) == 0) {
          curStage++;
        }
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.getCode()}');
        curStage--;
        return;
      }
      return;
    } catch (e) {
      print("Loading.echoHandler failure, $e");
      showMessageDialog(context, '温馨提示：', '未知错误');
      curStage--;
      return;
    }
  }

  void fetchRateLimitingConfigHandler(Map<String, dynamic> body) {
    print('Loading.fetchRateLimitingConfigHandler');
    try {
      FetchRateLimitingConfigRsp rsp = FetchRateLimitingConfigRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        Runtime.updateRateLimiter(rsp.rateLimiter);
        curStage++;
      } else {
        showMessageDialog(context, '温馨提示：', '错误代码  ${rsp.code}');
        curStage--;
        return;
      }
      return;
    } catch (e) {
      print("Loading.fetchRateLimitingConfigHandler failure, $e");
      showMessageDialog(context, '温馨提示：', '未知错误');
      curStage--;
      return;
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    print("Loading.observe: major: $major, minor: $minor");
    try {
      if (major == Major.gateway && minor == Minor.gateway.fetchRateLimitingConfigRsp) {
        fetchRateLimitingConfigHandler(body);
      } else if (major == Major.gateway && minor == Minor.gateway.pongRsp) {
        echoHandler(body);
      } else {
        print("Loading.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('Loading.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  void refresh() {
    print('Loading.refresh');
    setState(() {});
  }

  void navigate(String page) {
    print('fetchRateLimitingConfigHandler.navigate to $page');
    Navigate.to(context, Screen.build(page));
  }

  void setup() {
    print('Loading.setup');
    setup_();
    Runtime.setObserve(observe);
  }

  @override
  void dispose() {
    print('Loading.dispose');
    super.dispose();
  }

  @override
  void initState() {
    print('Loading.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    echo(message: message);
    fetchRateLimitingConfig();
    return StreamBuilder(
      stream: yeildData(),
      builder: (context, snap) {
        if (curStage == 0) {
          return const Center(child: CircularProgressIndicator());
        } else if (curStage == 1) {
          print('curStage == 1');
          return const Center(child: CircularProgressIndicator());
        } else if (curStage == 2) {
          print('curStage == 2');
          navigate(Screen.smsSignIn);
          return const Text('auth done');
        } else {
          return const Text('else case');
        }
      },
    );
  }
}
