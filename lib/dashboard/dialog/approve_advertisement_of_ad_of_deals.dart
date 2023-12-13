import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/business/admin/fetch_records_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_advertisement.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/dialog/fill_selling_point.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_good.dart';
import 'package:flutter_framework/common/business/admin/fetch_records_of_good.dart';
import 'package:flutter_framework/common/business/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_good.dart';

Future<int> showApproveAdvertisementOfADOfDealsDialog(BuildContext context) async {
  bool closed = false;
  int curStage = 0;

  var oriObserve = Runtime.getObserve();
  var advertisementIdController = TextEditingController();
  var advertisementNameController = TextEditingController();
  var productIdController = TextEditingController();
  var stockController = TextEditingController();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showApproveAdvertisementOfADOfDealsDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void fetchRecordsOfAdvertisementHandler(Map<String, dynamic> body) {
    try {
      FetchRecordsOfAdvertisementRsp rsp = FetchRecordsOfAdvertisementRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        if (rsp.getDataMap().length == 1) {
          rsp.getDataMap().forEach((key, value) {
            advertisementIdController.text = value.getId().toString();
            advertisementNameController.text = value.getName();
            productIdController.text = value.getProductId().toString();
            stockController.text = value.getStock().toString();
          });
          curStage++;
        } else if (rsp.getDataMap().isEmpty) {
          showMessageDialog(
            context,
            Translator.translate(Language.titleOfNotification),
            Translator.translate(Language.noRecordsMatchedTheSearchCondition),
          );
          return;
        }
      } else {
        // failure
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          '${Translator.translate(Language.failureWithErrorCode)}  ${rsp.getCode()}',
        );
        return;
      }
    } catch (e) {
      print('fetchRecordsOfAdvertisementHandler failure, err: $e');
    }
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("showInsertAdvertisementDialog.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.fetchRecordsOfAdvertisementRsp) {
        return fetchRecordsOfAdvertisementHandler(body);
      }
      print("showInsertAdvertisementDialog.observe warning: $major-$minor doesn't matched");
    } catch (e) {
      print('showInsertAdvertisementDialog.observe($major-$minor).e: ${e.toString()}');
      return;
    } finally {}
  }

  void resetController() {
    advertisementIdController.text = '';
    advertisementNameController.text = '';
    productIdController.text = '';
    stockController.text = '';
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Translator.translate(Language.approveAdvertisementToGroup)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 0),
            child: Text(Translator.translate(Language.cancel)),
          ),
          TextButton(
            onPressed: () async {
              if (advertisementIdController.text.isEmpty || productIdController.text.isEmpty || advertisementNameController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.advertisementOfADOfDealsNotProvided),
                );
                return;
              }
              Navigator.pop(context, int.parse(advertisementIdController.text));
            },
            child: Text(Translator.translate(Language.confirm)),
          ),
          // Spacing.AddVerticalSpace(50),
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
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: advertisementIdController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(11),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'^0+'), //users can't type 0 at 1st position
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.idOfAdvertisement),
                          labelStyle: const TextStyle(
                            color: Colors.redAccent,
                          ),
                          suffixIcon: IconButton(
                            tooltip: Translator.translate(Language.peekInfoFromAdvertisementId),
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              if (advertisementIdController.text.isEmpty) {
                                showMessageDialog(
                                  context,
                                  Translator.translate(Language.titleOfNotification),
                                  Translator.translate(Language.advertisementIdIsEmpty),
                                );
                                return;
                              }

                              fetchRecordsOfAdvertisement(
                                advertisementIdList: [int.parse(advertisementIdController.text)],
                              );

                              resetController();
                            },
                          ),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        readOnly: true,
                        controller: advertisementNameController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                              // color: Colors.redAccent,
                              ),
                          labelText: Translator.translate(Language.nameOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        readOnly: true,
                        controller: productIdController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.idOfGood),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        readOnly: true,
                        controller: stockController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.stockOfAdvertisement),
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
      if (value == null) {
        return 0;
      }
      return value;
    },
  );
}
