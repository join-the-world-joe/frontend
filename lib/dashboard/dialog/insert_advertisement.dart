import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/dialog/fill_selling_point.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/plugin/oss/aliyun/aliyun.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/convert.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_records_of_good.dart';
import 'package:flutter_framework/common/business/admin/fetch_records_of_good.dart';
import 'package:flutter_framework/common/business/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_good.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart' as path;

Future<void> showInsertAdvertisementDialog(BuildContext context) async {
  bool closed = false;
  int curStage = 0;
  String from = 'showInsertAdvertisementDialog';
  List<String> sellingPoints = [];
  html.File? thumbnail;
  List<String> urlsOfImage = [];

  var oriObserve = Runtime.getObserve();
  var productIdController = TextEditingController();
  var nameController = TextEditingController();
  var titleController = TextEditingController();
  var sellingPriceController = TextEditingController();
  var placeOfOriginController = TextEditingController();
  var sellingPointController = TextEditingController();
  var stockController = TextEditingController();
  var statusController = TextEditingController();
  var imageController = TextEditingController();

  Stream<int>? yeildData() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showInsertAdvertisementDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void insertRecordOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'insertRecordOfAdvertisementHandler';
    try {
      InsertRecordOfGoodRsp rsp = InsertRecordOfGoodRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        showMessageDialog(
          context,
          Translator.translate(Language.titleOfNotification),
          Translator.translate(Language.insertRecordSuccessfully),
        ).then(
          (value) {
            Navigator.pop(context, null);
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

  void fetchRecordsOfGoodHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchRecordsOfGoodHandler';
    try {
      FetchRecordsOfGoodRsp rsp = FetchRecordsOfGoodRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: '',
      );
      if (rsp.getCode() == Code.oK) {
        var key = int.parse(productIdController.text);
        if (rsp.getDataMap().containsKey(key)) {
          showMessageDialog(
            context,
            Translator.translate(Language.nameOfGood),
            rsp.getDataMap()[key]!.getName(),
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
        message: 'responded',
      );
      if (major == Major.admin && minor == Admin.insertRecordOfAdvertisementRsp) {
        insertRecordOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.fetchRecordsOfGoodRsp) {
        fetchRecordsOfGoodHandler(major: major, minor: minor, body: body);
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
              if (stockController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.incorrectStockValueInController),
                );
                return;
              }

              if (sellingPriceController.text.isEmpty) {
                showMessageDialog(
                  context,
                  Translator.translate(Language.titleOfNotification),
                  Translator.translate(Language.incorrectSellingPriceInController),
                );
                return;
              }

              insertRecordOfAdvertisement(
                from: from,
                caller: '$caller.insertRecordOfAdvertisement',
                name: nameController.text,
                title: titleController.text,
                sellingPrice: Convert.doubleStringMultiple10toInt(sellingPriceController.text),
                sellingPoints: sellingPoints,
                image: imageController.text,
                placeOfOrigin: placeOfOriginController.text,
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
                                fetchRecordsOfGood(
                                  from: from,
                                  caller: '$caller.fetchRecordsOfGood',
                                  productIdList: [int.parse(productIdController.text)],
                                );
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
                        readOnly: true,
                        controller: sellingPointController,
                        decoration: InputDecoration(
                          labelText: sellingPoints.isEmpty ? Translator.translate(Language.pressRightButtonToAddSellingPoint) : "",
                          suffixIcon: IconButton(
                            tooltip: Translator.translate(Language.addSellingPointToAdvertisement),
                            icon: const Icon(Icons.add_circle_outlined),
                            onPressed: () {
                              showFillSellingPointDialog(context).then((value) {
                                if (value.isNotEmpty) {
                                  sellingPoints.add(value);
                                  curStage++;
                                }
                              });
                            },
                          ),
                          prefixIcon: Wrap(
                            children: () {
                              List<Widget> widgetList = [];
                              for (var element in sellingPoints) {
                                widgetList.add(Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InputChip(
                                    label: Text(
                                      element,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onDeleted: () {
                                      sellingPoints.remove(element);
                                      curStage++;
                                    },
                                    backgroundColor: Colors.green,
                                    // selectedColor: Colors.green,
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                ));
                              }
                              return widgetList;
                            }(),
                          ),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: sellingPriceController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(Config.doubleRegExp),
                          LengthLimitingTextInputFormatter(Config.lengthOfSellingPrice),
                        ],
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(Config.lengthOfBuyingPrice),
                        ],
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
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        readOnly: true,
                        controller: imageController,
                        decoration: InputDecoration(
                          labelText: thumbnail == null ? Translator.translate(Language.pressRightButtonToAddThumbnail) : '',
                          suffixIcon: IconButton(
                            tooltip: () {
                              if (thumbnail == null) {
                                return Translator.translate(Language.pressToAddThumbnail);
                              } else {
                                return Translator.translate(Language.pressToModifyThumbnail);
                              }
                            }(),
                            icon: const Icon(Icons.add_circle_outlined),
                            onPressed: () async {
                              var mediaData = await ImagePickerWeb.getImageInfo;
                              String mimeType = path.extension(mediaData!.fileName!).toLowerCase();
                              print('mimeType: $mimeType');
                              print('size: ${mediaData.data!.length}');

                            },
                          ),
                          prefixIcon: Wrap(
                            children: () {
                              List<Widget> widgetList = [];
                              if (thumbnail != null) {
                                widgetList.add(Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InputChip(
                                    label: Text(
                                      thumbnail!.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      print('path: ${thumbnail!.relativePath}');
                                      print('size: ${thumbnail!.size}');
                                    },
                                    // onDeleted: () {
                                    //   sellingPoints.remove(element);
                                    //   curStage++;
                                    // },
                                    backgroundColor: Colors.green,
                                    // selectedColor: Colors.green,
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: const EdgeInsets.all(8.0),
                                  ),
                                ));
                              }
                              return widgetList;
                            }(),
                          ),
                        ),
                      ),
                    ),
                    Spacing.addVerticalSpace(10),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: imageController,
                        decoration: InputDecoration(
                          labelText: Translator.translate(Language.imageOfAdvertisement),
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
