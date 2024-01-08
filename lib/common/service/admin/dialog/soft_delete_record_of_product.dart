import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/business/soft_delete_records_of_product.dart';
import 'package:flutter_framework/common/service/admin/progress/soft_delete_record_of_product/soft_delete_records_of_product_progress.dart';
import 'package:flutter_framework/common/service/admin/progress/soft_delete_record_of_product/soft_delete_records_of_product_step.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_product.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/model/product.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import '../../../../dashboard/config/config.dart';

Future<bool> showSoftDeleteRecordsOfProductDialog(BuildContext context, Product product) async {
  var oriObserve = Runtime.getObserve();
  bool closed = false;
  int curStage = 0;
  String from = 'showSoftDeleteRecordsOfProductDialog';
  SoftDeleteRecordsOfProductProgress? softDeleteRecordsOfProductProgress;

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showRemoveProductDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void softDeleteRecordOfProductHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'softDeleteRecordOfProductHandler';
    try {
      var rsp = SoftDeleteRecordsOfProductRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (softDeleteRecordsOfProductProgress != null) {
        softDeleteRecordsOfProductProgress!.respond(rsp);
      }
    } catch (e) {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'failure, err: $e',
      );
      showMessageDialog(context, Translator.translate(Language.titleOfNotification), Translator.translate(Language.removeOperationFailure)).then((value) {
        Navigator.pop(context, false);
        curStage = -1;
      });
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
      if (major == Major.admin && minor == Admin.softDeleteRecordsOfProductRsp) {
        softDeleteRecordOfProductHandler(major: major, minor: minor, body: body);
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
      return AlertDialog(
        // actions: [
        // ],
        content: StreamBuilder(
          builder: (context, snap) {
            var caller = 'builder';
            // print('data: ${snap.data}');
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
                        Text('${Translator.translate(Language.nameOfProduct)} : ${product.getName()}'),
                        Spacing.addVerticalSpace(20),
                        Text('${Translator.translate(Language.vendorOfProduct)} : ${product.getVendor()}'),
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
                            if (softDeleteRecordsOfProductProgress == null) {
                              var step = SoftDeleteRecordsOfProductStep.construct();
                              step.setProductIdList([product.getId()]);
                              softDeleteRecordsOfProductProgress = SoftDeleteRecordsOfProductProgress.construct(
                                step: step,
                              );
                              softDeleteRecordsOfProductProgress!.show(context: context).then((value) {
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
                                  showWarningDialog(context, Translator.translate(Language.operationTimeout));
                                }
                                softDeleteRecordsOfProductProgress = null;
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
