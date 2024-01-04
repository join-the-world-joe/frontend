import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/service/admin/progress/insert_record_of_product/insert_record_of_product_progress.dart';
import 'package:flutter_framework/common/service/admin/progress/insert_record_of_product/insert_record_of_product_step.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_product.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../../../../dashboard/config/config.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_product.dart';

Future<void> showInsertRecordOfProductDialog(BuildContext context) async {
  bool closed = false;
  int curStage = 0;
  int status = int.parse('1');
  String from = 'showInsertRecordOfProductDialog';
  InsertRecordOfProductProgress? insertRecordOfProductProgress;

  var oriObserve = Runtime.getObserve();
  var nameController = TextEditingController();
  var buyingPriceController = TextEditingController();
  var vendorController = TextEditingController();
  var contactController = TextEditingController();

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

  void insertRecordOfProductHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'insertRecordOfProductHandler';
    try {
      var rsp = InsertRecordOfProductRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (insertRecordOfProductProgress != null) {
        insertRecordOfProductProgress!.respond(rsp);
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
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();
    var caller = 'observe';

    try {
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.insertRecordOfProductRsp) {
        insertRecordOfProductHandler(major: major, minor: minor, body: body);
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
    } finally {}
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var caller = 'builder';
      return AlertDialog(
        title: Text(Translator.translate(Language.importProduct)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(Translator.translate(Language.cancel)),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.productNameNotProvided),
                );
                return;
              }
              if (buyingPriceController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.buyingPriceNotProvided),
                );
                return;
              }
              if (insertRecordOfProductProgress == null) {
                var step = InsertRecordOfProductStep.construct();
                step.setName(nameController.text);
                step.setVendor(vendorController.text);
                step.setContact(contactController.text);
                step.setBuyingPrice(Convert.doubleStringMultiple10toInt(buyingPriceController.text));
                insertRecordOfProductProgress = InsertRecordOfProductProgress.construct(
                  result: Code.internalError,
                  step: step,
                  message: Translator.translate(Language.tryingToInsertRecordOfProduct),
                );
                insertRecordOfProductProgress!.show(context: context).then((value) {
                  if (value == Code.oK) {
                    showMessageDialog(
                      context,
                      Translator.translate(Language.titleOfNotification),
                      Translator.translate(Language.insertRecordSuccessfully),
                    ).then(
                      (value) {
                        Navigator.pop(context, null);
                      },
                    );
                  } else {
                    showWarningDialog(context, Translator.translate(Language.operationTimeout));
                  }
                  insertRecordOfProductProgress = null;
                });
              }
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          // Spacing.AddVerticalSpace(50),
        ],
        content: StreamBuilder(
          stream: stream(),
          builder: (context, snap) {
            return SizedBox(
              width: 450,
              height: 435,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: 350,
                      child: Row(
                        children: [
                          Spacing.addHorizontalSpace(85),
                          Text(Translator.translate(Language.enable)),
                          Radio<int?>(
                              value: 1,
                              groupValue: status,
                              onChanged: (b) {
                                status = b!;
                                curStage++;
                                // print("status: $b");
                              }),
                          Spacing.addHorizontalSpace(50),
                          Text(Translator.translate(Language.disable)),
                          Radio<int?>(
                            value: 0,
                            groupValue: status,
                            onChanged: (b) {
                              status = b!;
                              curStage++;
                              // print("status: $b");
                            },
                          ),
                        ],
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.nameOfProduct),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: buyingPriceController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(Config.lengthOfBuyingPrice),
                          FilteringTextInputFormatter.allow(Config.doubleRegExp),
                        ],
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.buyingPrice),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: vendorController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.vendorOfProduct),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: contactController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.contactOfVendor),
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
    },
  );
}
