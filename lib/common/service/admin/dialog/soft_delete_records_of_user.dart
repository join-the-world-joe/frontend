import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/progress/soft_delete_record_of_user/soft_delete_record_of_user_progress.dart';
import 'package:flutter_framework/common/service/admin/progress/soft_delete_record_of_user/soft_delete_record_of_user_step.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_user.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import '../../../../dashboard/config/config.dart';

Future<bool> showSoftDeleteRecordsOfUserDialog(BuildContext context, User user) async {
  var oriObserve = Runtime.getObserve();
  bool closed = false;
  int curStage = 0;
  String from = 'showSoftDeleteRecordsOfUserDialog';
  SoftDeleteRecordsOfUserProgress? softDeleteRecordsOfUserProgress;

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showRemoveUserDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        // print('showPermissionListOfUserDialog.last: $lastStage');
        yield lastStage;
      }
    }
  }

  void softDeleteRecordsOfUserHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'softDeleteRecordsOfUserHandler';
    try {
      var rsp = SoftDeleteRecordsOfUserRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (softDeleteRecordsOfUserProgress != null) {
        softDeleteRecordsOfUserProgress!.respond(rsp);
      }
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
      if (major == Major.admin && minor == Admin.softDeleteRecordOfUserRsp) {
        softDeleteRecordsOfUserHandler(major: major, minor: minor, body: body);
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

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      var caller = 'builder';
      return AlertDialog(
        // actions: [
        // ],
        content: StreamBuilder(
          builder: (context, snap) {
            print('data: ${snap.data}');
            // if (snap.data != null) {
            return SizedBox(
              width: 220,
              height: 180,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID ：${user.getId()}'),
                        Spacing.addVerticalSpace(20),
                        Text('${Translator.translate(Language.fName)} ：${user.getName()}'),
                        Spacing.addVerticalSpace(20),
                        Text('${Translator.translate(Language.fPhoneNumber)} ：${user.getPhoneNumber()}'),
                        Spacing.addVerticalSpace(20),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: Text(Translator.translate(Language.cancel)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (softDeleteRecordsOfUserProgress == null) {
                              var step = SoftDeleteRecordsOfUserStep.construct(userIdList: [int.parse(user.getId())]);
                              softDeleteRecordsOfUserProgress = SoftDeleteRecordsOfUserProgress.construct(
                                step: step,
                              );
                              softDeleteRecordsOfUserProgress!.show(context: context).then((value) {
                                if (value == Code.oK) {
                                  showMessageDialog(
                                    context,
                                    Translator.translate(Language.titleOfNotification),
                                    Translator.translate(Language.removeRecordSuccessfully),
                                  ).then(
                                    (value) {
                                      Navigator.pop(context, true);
                                    },
                                  );
                                } else {
                                  showMessageDialog(
                                    context,
                                    Translator.translate(Language.titleOfNotification),
                                    '${Translator.translate(Language.failureWithErrorCode)}  ${step.getCode()}',
                                  );
                                }
                                softDeleteRecordsOfUserProgress = null;
                              });
                            }
                          },
                          child: Text(Translator.translate(Language.confirm)),
                        ),
                        Spacing.addVerticalSpace(50),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          stream: stream(),
        ),
      );
    },
  ).then((value) {
    closed = true;
    Runtime.setObserve(oriObserve);
    return value;
  });
}
