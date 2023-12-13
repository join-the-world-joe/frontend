import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/business/admin/soft_delete_records_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_user_record.dart';

Future<bool> showRejectAdvertisementOfADOfDealsDialog(BuildContext context, String id, String name) async {
  var oriObserve = Runtime.getObserve();
  bool closed = false;
  int curStage = 0;

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showRemoveAdvertisementDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("showRejectAdvertisementOfDealsDialog.observe: major: $major, minor: $minor");
      print("showRejectAdvertisementOfDealsDialog.observe warning: $major-$minor doesn't matched");
      return;
    } catch (e) {
      print('showRejectAdvertisementOfDealsDialog.observe($major-$minor).e: ${e.toString()}');
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
                            Navigator.pop(context, false);
                          },
                          child: Text(Translator.translate(Language.cancel)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
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
    return value;
  });
}
