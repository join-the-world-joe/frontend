import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/business/fetch_records_of_good.dart';
import 'package:flutter_framework/dashboard/business/insert_record_of_advertisement.dart';
import 'package:flutter_framework/dashboard/business/insert_record_of_good.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';

Future<void> showInsertAdvertisementDialog(BuildContext context) async {
  bool closed = false;
  int curStage = 0;
  int status = int.parse('1');

  var oriObserve = Runtime.getObserve();
  var productIdController = TextEditingController();
  var nameController = TextEditingController();
  var titleController = TextEditingController();
  var sellingPriceController = TextEditingController();
  var placeOfOriginController = TextEditingController();
  var sellingPointController = TextEditingController();
  var stockController = TextEditingController();
  var urlController = TextEditingController();
  var descController = TextEditingController();

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

  void insertRecordOfAdvertisementHandler(Map<String, dynamic> body) {
    try {
      InsertRecordOfGoodRsp rsp = InsertRecordOfGoodRsp.fromJson(body);
      if (rsp.code == Code.oK) {
        showMessageDialog(context, '温馨提示：', '插入成功').then(
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
      print("showInsertAdvertisementDialog.insertUserRecordHandler failure, $e");
      return;
    }
  }

  void fetchRecordsOfGoodHandler(Map<String, dynamic> body) {
    try {
      FetchRecordsOfGoodRsp rsp = FetchRecordsOfGoodRsp.fromJson(body);
      if (rsp.getCode() == Code.oK) {
        var key = int.parse(productIdController.text);
        if (rsp.productMap.containsKey(key)) {
          showMessageDialog(
            context,
            Translator.translate(Language.nameOfGood),
            rsp.productMap[key]!.getName(),
          );
          curStage++;
        } else {
          showMessageDialog(
            context,
            Translator.translate(Language.titleOfNotification),
            Translator.translate(Language.withoutProductInfoInResponse),
          );
        }
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
      print("showInsertAdvertisementDialog.fetchRecordsOfGoodHandler failure, $e");
      return;
    } finally {}
  }

  void observe(PacketClient packet) {
    var major = packet.getHeader().getMajor();
    var minor = packet.getHeader().getMinor();
    var body = packet.getBody();

    try {
      print("showInsertAdvertisementDialog.observe: major: $major, minor: $minor");
      if (major == Major.admin && minor == Minor.admin.insertRecordOfAdvertisementRsp) {
        insertRecordOfAdvertisementHandler(body);
      }
      if (major == Major.admin && minor == Minor.admin.fetchRecordsOfGoodRsp) {
        fetchRecordsOfGoodHandler(body);
      } else {
        print("showInsertAdvertisementDialog.observe warning: $major-$minor doesn't matched");
      }
      return;
    } catch (e) {
      print('showInsertAdvertisementDialog.observe($major-$minor).e: ${e.toString()}');
      return;
    } finally {}
  }

  Runtime.setObserve(observe);

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Translator.translate(Language.newAdvertisement)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(Translator.translate(Language.cancel)),
          ),
          TextButton(
            onPressed: () async {
              if (productIdController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.productIdIsEmpty),
                );
                return;
              }
              if (nameController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.nameOfAdvertisementIsEmpty),
                );
                return;
              }
              insertRecordOfAdvertisement(
                name: nameController.text,
                title: titleController.text,
                sellingPrice: int.parse(sellingPriceController.text),
                sellingPoint: sellingPointController.text,
                url: urlController.text,
                placeOfOrigin: placeOfOriginController.text,
                description: descController.text,
                status: status,
                stock: int.parse(stockController.text),
                productId: int.parse(productIdController.text),
              );
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
                        controller: productIdController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.idOfGood),
                          labelStyle: const TextStyle(
                            color: Colors.redAccent,
                          ),
                          suffixIcon: IconButton(
                            tooltip: Translator.translate(Language.peekInfoFromProductId),
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              if (productIdController.text.isEmpty) {
                                showMessageDialog(
                                  context,
                                  Translator.translate(Language.titleOfNotification),
                                  Translator.translate(Language.productIdIsEmpty),
                                );
                                return;
                              } else {
                                fetchRecordsOfGood(productList: [int.parse(productIdController.text)]);
                                return;
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.redAccent,
                          ),
                          labelText: Translator.translate(Language.nameOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.titleOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: sellingPointController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.sellingPointsOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: sellingPriceController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.sellingPriceOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: stockController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.stockOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: placeOfOriginController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.placeOfOriginOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: urlController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.urlOfAdvertisement),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: descController,
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
    },
  );
}