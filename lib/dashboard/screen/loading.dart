import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/route/backend_gateway.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/navigate.dart';
import '../screen/screen.dart';
import '../setup.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_framework/common/protocol/backend_gateway/echo.dart';
import 'package:flutter_framework/common/business/backend_gateway/echo.dart';
import 'package:flutter_framework/common/protocol/backend_gateway/fetch_rate_limiting_config.dart';
import 'package:flutter_framework/common/business/backend_gateway/fetch_rate_limiting_config.dart';

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
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('Loading, last: $lastStage, cur: $curStage');
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

  void echoHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'echoHandler';
    try {
      PongRsp rsp = PongRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.loading,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        if (message.compareTo(rsp.getMessage()) == 0) {
          curStage++;
          fCheckPong = true;
        }
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.loading,
        caller: caller,
        message: 'failure, err: $e',
      );
    } finally {}
  }

  void fetchRateLimitingConfigHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchRateLimitingConfigHandler';
    try {
      FetchRateLimitingConfigRsp rsp = FetchRateLimitingConfigRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.loading,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        Runtime.updateRateLimiter(rsp.getRateLimiter());
        fGetRateLimiting = true;
        curStage++;
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.loading,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    } finally {}
  }

  void observe(PacketClient packet) {
    var caller = "observe";
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    try {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.loading,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.backendGateway && minor == BackendGateway.fetchRateLimitingConfigRsp) {
        fetchRateLimitingConfigHandler(major: major, minor: minor, body: body);
      } else if (major == Major.backendGateway && minor == BackendGateway.pongRsp) {
        echoHandler(major: major, minor: minor, body: body);
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: Screen.loading,
          caller: caller,
          message: 'not matched',
        );
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: Screen.loading,
        caller: caller,
        message: 'failure, err: $e',
      );
    } finally {}
  }

  void refresh() {
    setState(() {});
  }

  void setup() {
    var caller = 'setup';
    setup_();
    Runtime.setObserve(observe);
    echo(
      from: Screen.loading,
      caller: '$caller.echo',
      message: message,
    );
    fetchRateLimitingConfig(
      from: Screen.loading,
      caller: '$caller.fetchRateLimitingConfig',
    );
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
