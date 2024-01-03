import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/service/admin/business/update_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/progress/update_record_of_product/update_record_of_product_progress.dart';
import 'package:flutter_framework/common/service/admin/progress/update_record_of_product/update_record_of_product_step.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import '../model/product.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/service/admin/protocol/update_record_of_product.dart';

Future<bool> showUpdateRecordOfProductDialog(BuildContext context, Product product) async {
  int curStage = 0;
  bool closed = false;
  String from = 'showUpdateRecordOfProductDialog';
  var oriObserve = Runtime.getObserve();
  var nameController = TextEditingController(text: product.getName());
  var vendorController = TextEditingController(text: product.getVendor());
  var contactController = TextEditingController(text: product.getContact());
  var buyingPriceController = TextEditingController(text: Convert.intDivide10toDoubleString(product.getBuyingPrice()));
  var idController = TextEditingController(text: product.getId().toString());

  UpdateRecordOfProductProgress? updateRecordOfProductProgress;

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showUpdateProductDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void updateRecordOfProductHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'updateRecordOfProductHandler';
    try {
      var rsp = UpdateRecordOfProductRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (updateRecordOfProductProgress != null) {
        updateRecordOfProductProgress!.respond(rsp);
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
    } finally {}
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
        message: '',
      );
      if (major == Major.admin && minor == Admin.updateRecordOfProductRsp) {
        updateRecordOfProductHandler(major: major, minor: minor, body: body);
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
    barrierDismissible: false,
    context: context,
    builder: (context) {
      var caller = 'builder';
      return AlertDialog(
        title: Text(Translator.translate(Language.modifyProduct)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Translator.translate(Language.cancel)),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                await showWarningDialog(context, Translator.translate(Language.productNameNotProvided));
                return;
              }
              if (buyingPriceController.text.isEmpty) {
                await showWarningDialog(context, Translator.translate(Language.buyingPriceNotProvided));
                return;
              }
              if (vendorController.text.isEmpty) {
                await showWarningDialog(context, Translator.translate(Language.vendorOfProductNotProvided));
                return;
              }
              if (contactController.text.isEmpty) {
                await showWarningDialog(context, Translator.translate(Language.contactOfVendorNotProvided));
                return;
              }
              if (updateRecordOfProductProgress == null) {
                var step = UpdateRecordOfProductStep.construct();
                step.setName(nameController.text);
                step.setVendor(vendorController.text);
                step.setContact(contactController.text);
                step.setProductId(idController.text);
                step.setBuyingPrice(buyingPriceController.text);
                updateRecordOfProductProgress = UpdateRecordOfProductProgress.construct(
                  result: Code.internalError,
                  step: step,
                  message: Translator.translate(Language.tryingToUpdateRecordOfProduct),
                );
                updateRecordOfProductProgress!.show(context: context).then((value) {
                  if (value == Code.oK) {
                    showMessageDialog(
                      context,
                      Translator.translate(Language.titleOfNotification),
                      Translator.translate(Language.updateRecordSuccessfully),
                    ).then(
                          (value) {
                        Navigator.pop(context, true);
                      },
                    );
                  } else {
                    showWarningDialog(context, Translator.translate(Language.operationTimeout));
                  }
                  updateRecordOfProductProgress = null;
                });
              }
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          Spacing.addVerticalSpace(50),
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
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: buyingPriceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(Config.doubleRegExp),
                          LengthLimitingTextInputFormatter(Config.lengthOfBuyingPrice),
                        ],
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.buyingPrice),
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
      return value;
    },
  );
}
