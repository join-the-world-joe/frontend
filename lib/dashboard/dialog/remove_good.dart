import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/model/product.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/business/admin/soft_delete_records_of_good.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_user_record.dart';

Future<bool> showRemoveGoodDialog(BuildContext context, Product product) async {
  var oriObserve = Runtime.getObserve();
  bool closed = false;
  int curStage = 0;
  String from = 'showRemoveGoodDialog';

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showRemoveGoodDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void softDeleteRecordOfGoodHandler(String routingKey, Map<String, dynamic> body) {
    var self = '${from}.softDeleteRecordOfGoodHandler';
    var prompt = '$self($routingKey)';
    try {
      SoftDeleteUserRecordRsp rsp = SoftDeleteUserRecordRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        if (Config.debug) {
          print("$prompt, code: ${rsp.getCode()}");
        }
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.removeRecordSuccessfully),
        ).then(
          (value) {
            Navigator.pop(context, true);
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
      print("$prompt, $e");
      showMessageDialog(context, Translator.translate(Language.titleOfNotification), Translator.translate(Language.removeOperationFailure)).then((value) {
        Navigator.pop(context, false);
        curStage = -1;
      });
      return;
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var routingKey = '$major-$minor';
    var body = packet.getBody();

    try {
      print("$from.observe: $routingKey");
      if (major == Major.admin && minor == Admin.softDeleteRecordsOfGoodRsp) {
        softDeleteRecordOfGoodHandler(routingKey, body);
      } else {
        print("$from.observe warning: $routingKey doesn't matched");
      }
      return;
    } catch (e) {
      print('$from.observe($routingKey).e: ${e.toString()}');
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
                        Text('ID ：${product.getId()}'),
                        Spacing.addVerticalSpace(20),
                        Text('${Translator.translate(Language.nameOfGood)} : ${product.getName()}'),
                        Spacing.addVerticalSpace(20),
                        Text('${Translator.translate(Language.vendorOfGood)} : ${product.getVendor()}'),
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
                            softDeleteRecordsOfGood(from: from, productIdList: [product.getId()]);
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
