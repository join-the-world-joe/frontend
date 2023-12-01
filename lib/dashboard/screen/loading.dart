import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
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
          print('Loading.navigate to $page');
          Navigate.to(context, Screen.build(page));
        },
      );
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
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}${rsp.getCode()}',
        );
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
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}${rsp.code}',
        );
        curStage--;
        return;
      }
      return;
    } catch (e) {
      print("Loading.fetchRateLimitingConfigHandler failure, $e");
      showMessageDialog(
        context,
        Translator.translate(Language.titleOfNotification),
        Translator.translate(Language.failureWithErrorCode),
      );
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
      if (major == Major.backendGateway && minor == Minor.backendGateway.fetchRateLimitingConfigRsp) {
        fetchRateLimitingConfigHandler(body);
      } else if (major == Major.backendGateway && minor == Minor.backendGateway.pongRsp) {
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
    // print('Loading.refresh');
    setState(() {});
  }

  void setup() {
    // print('Loading.setup');
    setup_();
    Runtime.setObserve(observe);
  }

  @override
  void dispose() {
    // print('Loading.dispose');
    super.dispose();
  }

  @override
  void initState() {
    // print('Loading.initState');
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    echo(message: message);
    fetchRateLimitingConfig();
    return StreamBuilder(
      stream: stream(),
      builder: (context, snap) {
        if (!Runtime.getConnectivity()) {
          navigate(Screen.offline);
          return const Text('');
        }
        if (curStage == 0) {
          return const Center(child: CircularProgressIndicator());
        } else if (curStage == 1) {
          // print('curStage == 1');
          return const Center(child: CircularProgressIndicator());
        } else if (curStage == 2) {
          print('curStage == 2');
          navigate(Screen.smsSignIn);
          return const Text(''); // done
        } else {
          return const Text(''); // fail
        }
      },
    );
  }
}
