import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/business/oss/remove_list_of_object_file.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/progress/remove_list_of_object_file_progress.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_records_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/oss/remove_list_of_object_file.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/oss.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/dialog/soft_delete_records_of_advertisement_progress.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/local/image_item.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import '../config/config.dart';
import 'package:path/path.dart' as path;

Future<bool> showRemoveRecordOfAdvertisementDialog(BuildContext context, int id, String name, String image) async {
  var oriObserve = Runtime.getObserve();
  double width = 220;
  double height = 150;
  bool closed = false;
  int curStage = 0;
  String from = 'showRemoveRecordOfAdvertisementDialog';
  var commonPath = '';
  Map<String, ImageItem> imageMap = {}; // key: key of advertisement in database or native file name
  SoftDeleteRecordsOfAdvertisementProgressDialog? softDeleteRecordProgress;
  RemoveListOfObjectFileProgress? removeObjectFileProgress;
  List<String> objectFileToBeRemoved = [];
  Stream<int>? stream() async* {
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

  try {
    String extension = '';
    var oriObjectFileName = '';
    Map<String, dynamic> imageOfAdvertisement = jsonDecode(image);
    imageOfAdvertisement.forEach((key, value) {
      extension = path.extension(value).toLowerCase();
      oriObjectFileName = '$id/$key$extension';
      imageMap[key] = ImageItem.construct(
        native: false,
        data: Uint8List(0),
        objectFileName: oriObjectFileName,
        url: value,
        nativeFileName: '',
        width: 0,
        height: 0,
      );
      objectFileToBeRemoved.add(oriObjectFileName);
    });
  } catch (e) {
    print('showRemoveAdvertisementDialog failure, err: $e');
  } finally {
    // print('Image map: ');
    // imageMap.forEach(
    //   (key, value) {
    //     print('key: $key, dbKey: ${value.getDBKey()}, objectFile: ${value.getObjectFile()}, url: ${value.getUrl()}');
    //   },
    // );
  }

  void softDeleteRecordOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'softDeleteRecordOfAdvertisementHandler';
    try {
      var rsp = SoftDeleteRecordsOfAdvertisementRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (softDeleteRecordProgress != null) {
        softDeleteRecordProgress!.respond(rsp);
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

  void removeListOfObjectFileHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'removeListOfObjectFileHandler';
    try {
      var rsp = RemoveListOfObjectFileRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        return;
      } else {
        // error occurs
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
      if (major == Major.admin && minor == Admin.softDeleteRecordsOfAdvertisementRsp) {
        softDeleteRecordOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else if (major == Major.oss && minor == OSS.removeListOfObjectFileRsp) {
        removeListOfObjectFileHandler(major: major, minor: minor, body: body);
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

  void setup() {
    Runtime.setObserve(observe);
  }

  setup();

  return await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      var caller = 'builder';
      return AlertDialog(
        // actions: [
        // ],
        content: StreamBuilder(
          builder: (context, snap) {
            return SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
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
                            Navigator.pop(context);
                          },
                          child: Text(Translator.translate(Language.cancel)),
                        ),
                        TextButton(
                          onPressed: () {
                            removeListOfObjectFile(
                              from: from,
                              caller: caller,
                              listOfObjectFile: objectFileToBeRemoved,
                            );
                            if (softDeleteRecordProgress == null) {
                              softDeleteRecordProgress = SoftDeleteRecordsOfAdvertisementProgressDialog.construct(
                                result: Code.internalError,
                              );
                              softDeleteRecordProgress!.setAdvertisementIdList([id]);
                              softDeleteRecordProgress!.show(context: context).then((value) {
                                if (value == Code.oK) {
                                  showMessageDialog(
                                    context,
                                    Translator.translate(Language.titleOfNotification),
                                    Translator.translate(Language.removeRecordSuccessfully),
                                  ).then(
                                    (value) {
                                      Navigator.pop(context);
                                      curStage++;
                                    },
                                  );
                                } else {
                                  showWarningDialog(context, Translator.translate(Language.operationTimeout));
                                }
                                softDeleteRecordProgress = null;
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
    return curStage > 0;
  });
}
