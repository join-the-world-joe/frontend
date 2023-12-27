import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/oss.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../config/config.dart';

Future<int> showSignInProgressDialog(
  BuildContext context, {
  required String email,
  required String memberId,
  required String account,
  required int behavior,
  required Uint8List password,
  required String phoneNumber,
  required String countryCode,
  required int verificationCode,
  required int userId,
}) async {
  var result = Code.internalError;
  bool closed = false;
  int curStage = 0;
  var from = 'showSignInProgressDialog';
  var oriObserve = Runtime.getObserve();

  String information = '';
  double height = 100;
  double width = 200;

  bool hasFigureStepNOutArgument = false;

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void progress() {
    var caller = 'progress';

    result = 0;
    Navigator.pop(context);
    return;
  }

  void observe(PacketClient packet) {
    var caller = 'observe';
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.oss && minor == OSS.fetchHeaderListOfObjectFileListOfAdvertisementRsp) {
      } else {
        Log.debug(
          major: major,
          minor: minor,
          from: from,
          caller: caller,
          message: 'not matched',
        );
      }
      return;
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
      return;
    }
  }

  void setup() {
    Runtime.setObserve(observe);
    Runtime.setPeriod(Config.periodOfScreenInitialisation);
    Runtime.setPeriodic(progress);
  }

  setup();

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Translator.translate(Language.modifyAdvertisement)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Translator.translate(Language.cancel)),
          ),
        ],
        content: StreamBuilder(
          stream: stream(),
          builder: (context, snap) {
            return SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(information),
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  ).then(
    (value) {
      closed = true;
      Runtime.setObserve(oriObserve);
      Runtime.setPeriod(Config.periodOfScreenNormal);
      Runtime.setPeriodic(null);
      return result;
    },
  );
}
