import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/business/insert_record_of_good.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';

Future<String> showFillSellingPointDialog(BuildContext context) async {
  bool closed = false;
  int curStage = 0;

  var oriObserve = Runtime.getObserve();
  var sellingPointController = TextEditingController();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      // print('showInsertGoodDialog, last: $lastStage, cur: ${curStage}');
      await Future.delayed(const Duration(milliseconds: 100));
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
      print("showInsertGoodDialog.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.insertRecordOfGoodRsp) {
      } else {
        print("showInsertGoodDialog.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('showInsertGoodDialog.observe($major-$minor).e: ${e.toString()}');
      return;
    } finally {}
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Translator.translate(Language.fillSellingPoint)),
        actions: [
          // TextButton(
          //   onPressed: () => Navigator.pop(context, ""),
          //   child: Text(Translator.translate(Language.cancel)),
          // ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, "");
              return;
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          // Spacing.AddVerticalSpace(50),
        ],
        content: StreamBuilder(
          stream: yeildData(),
          builder: (context, snap) {
            return SizedBox(
              width: 150,
              height: 80,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        controller: sellingPointController,
                        decoration: const InputDecoration(
                            // labelText: Translator.translate(Language.sellingPointsOfAdvertisement),
                            ),
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
      return sellingPointController.text;
    },
  );
}