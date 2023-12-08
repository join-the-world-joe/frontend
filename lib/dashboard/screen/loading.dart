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
  bool fGetRateLimiting = false;
  bool fCheckPong = false;

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
    try {
      PongRsp rsp = PongRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        if (message.compareTo(rsp.getMessage()) == 0) {
          curStage++;
          fCheckPong = true;
        }
      }
    } catch (e) {
      print("Loading.echoHandler failure, $e");
    } finally {}
  }

  void fetchRateLimitingConfigHandler(Map<String, dynamic> body) {
    try {
      FetchRateLimitingConfigRsp rsp = FetchRateLimitingConfigRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        Runtime.updateRateLimiter(rsp.getRateLimiter());
        fGetRateLimiting = true;
        curStage++;
      }
    } catch (e) {
      print("Loading.fetchRateLimitingConfigHandler failure, $e");
      return;
    } finally {}
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
    } catch (e) {
      print('Loading.observe failure($major-$minor), e: ${e.toString()}');
    } finally {
    }
  }

  void refresh() {
    setState(() {});
  }

  void setup() {
    setup_();
    Runtime.setObserve(observe);
    echo(message: message);
    fetchRateLimitingConfig();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          if (fCheckPong && fGetRateLimiting) {
            navigate(Screen.smsSignIn);
          }
          return const Text(''); // done
        } else {
          return const Text(''); // fail
        }
      },
    );
  }
}
