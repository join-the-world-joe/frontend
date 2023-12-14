import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_user_record.dart';
import 'package:flutter_framework/common/business//admin/soft_delete_user_record.dart';

Future<bool> showRemoveUserDialog(BuildContext context, User user) async {
  var oriObserve = Runtime.getObserve();
  bool closed = false;
  int curStage = 0;
  String from = 'showRemoveUserDialog';

  Stream<int>? yeildData() async* {
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

  void softDeleteUserRecordHandler(Map<String, dynamic> body) {
    print('showRemoveUserDialog.softDeleteUserRecordHandler');
    try {
      SoftDeleteUserRecordRsp rsp = SoftDeleteUserRecordRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        showMessageDialog(context, '温馨提示：', '删除成功').then(
          (value) {
            Navigator.pop(context);
            curStage++;
          },
        );
        return;
      } else {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
        return;
      }
    } catch (e) {
      print("showRemoveUserDialog failure, $e");
      showMessageDialog(context, '温馨提示：', '删除失败').then((value) {
        Navigator.pop(context);
        curStage = -1;
      });
      return;
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("showRemoveUserDialog.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Admin.softDeleteUserRecordRsp) {
        softDeleteUserRecordHandler(body);
      } else {
        print("showRemoveUserDialog.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('showRemoveUserDialog.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
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
                            Navigator.pop(context);
                          },
                          child: Text(Translator.translate(Language.cancel)),
                        ),
                        TextButton(
                          onPressed: () {
                            softDeleteUserRecord(from: from, userList: [int.parse(user.getId())]);
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
            // }
            // return const SizedBox(
            //   width: 400,
            //   height: 250,
            //   child: Center(child: CircularProgressIndicator()),
            // );
          },
          stream: yeildData(),
        ),
      );
    },
  ).then((value) {
    closed = true;
    Runtime.setObserve(oriObserve);
    return curStage > 0;
  });
}
