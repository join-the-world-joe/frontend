import 'package:flutter/material.dart';
import 'package:flutter_framework/dashboard/business/update_record_of_advertisement.dart';
import 'package:flutter_framework/dashboard/business/update_record_of_good.dart';
import 'package:flutter_framework/dashboard/business/update_user_record.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/business/fetch_role_list_of_condition.dart';
import 'package:flutter_framework/dashboard/business/insert_user_record.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/model/role.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/dashboard/model/user.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../model/advertisement.dart';

Future<bool> showUpdateAdvertisementDialog(BuildContext context, Advertisement advertisement) async {
  int status = advertisement.getStatus();
  int curStage = 0;
  bool closed = false;
  var oriObserve = Runtime.getObserve();
  var nameController = TextEditingController(text: product.getName());
  var vendorController = TextEditingController(text: product.getVendor());
  var contactController = TextEditingController(text: product.getContact());
  var descriptionController = TextEditingController(text: product.getDescription());
  var buyingPriceController = TextEditingController(text: product.getBuyingPrice().toString());
  var idController = TextEditingController(text: product.getId().toString());

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

  void updateRecordOfGoodHandler(Map<String, dynamic> body) {
    try {
      UpdateRecordOfGoodRsp rsp = UpdateRecordOfGoodRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        showMessageDialog(context, '温馨提示：', '更新成功').then(
              (value) {
            Navigator.pop(context, null);
          },
        );
        return;
      } else {
        showMessageDialog(context, '温馨提示：', '未知错误  ${rsp.code}');
        return;
      }
    } catch (e) {
      print("showUpdateGoodDialog.updateRecordOfGoodHandler failure, $e");
      return;
    } finally {}
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("showUpdateGoodDialog.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.updateRecordOfGoodRsp) {
        print('body: ${body.toString()}');
        updateRecordOfGoodHandler(body);
      } else {
        print("showUpdateGoodDialog.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('showUpdateGoodDialog.observe($major-$minor).e: ${e.toString()}');
      return;
    }
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Translator.translate(Language.modifyGood)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Translator.translate(Language.cancel)),
          ),
          TextButton(
            onPressed: () async {
              updateRecordOfAdvertisement(
                name: nameController.text,
                productId: int.parse(idController.text),
                buyingPrice: int.parse(buyingPriceController.text),
                status: status,
                vendor: vendorController.text,
                contact: contactController.text,
                description: descriptionController.text,
              );
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          Spacing.addVerticalSpace(50),
        ],
        content: StreamBuilder(
          stream: yeildData(),
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
                            },
                          ),
                          Spacing.addHorizontalSpace(50),
                          Text(Translator.translate(Language.disable)),
                          Radio<int?>(
                            value: 0,
                            groupValue: status,
                            onChanged: (b) {
                              status = b!;
                              curStage++;
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
                          labelText: Translator.translate(Language.nameOfGood),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: vendorController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.vendorOfGood),
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
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.buyingPrice),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.description),
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
