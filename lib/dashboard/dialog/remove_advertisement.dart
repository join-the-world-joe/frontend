import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/business/soft_delete_records_of_advertisement.dart';
import 'package:flutter_framework/dashboard/business/soft_delete_records_of_good.dart';
import 'package:flutter_framework/dashboard/business/soft_delete_user_recode.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/component/good.dart';
import 'package:flutter_framework/dashboard/model/product.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';

Future<bool> showRemoveAdvertisementDialog(BuildContext context, int id, String name) async {
  var oriObserve = Runtime.getObserve();
  bool closed = false;
  int curStage = 0;

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void softDeleteRecordOfAdvertisementHandler(Map<String, dynamic> body) {
    print('showRemoveAdvertisementDialog.softDeleteRecordOfAdvertisementHandler');
    try {
      SoftDeleteUserRecordRsp rsp = SoftDeleteUserRecordRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.removeRecordSuccessfully),
        ).then(
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
        ).then((value) {
          Navigator.pop(context);
          curStage = -1;
        });
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
      if (major == Major.admin && minor == Minor.admin.softDeleteRecordsOfAdvertisementRsp) {
        softDeleteRecordOfAdvertisementHandler(body);
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
              height: 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID ：${id}'),
                        Spacing.addVerticalSpace(20),
                        Text('${Translator.translate(Language.nameOfAdvertisement)} : $name'),
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
                            softDeleteRecordsOfAdvertisement(advertisementIdList: [id]);
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
