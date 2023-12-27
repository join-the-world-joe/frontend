import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/progress/fetch_header_list_of_object_file_list_of_advertisement_progress.dart';
import 'package:flutter_framework/common/progress/remove_list_of_object_file_progress.dart';
import 'package:flutter_framework/common/progress/upgrade_fields_of_advertisement_progress.dart';
import 'package:flutter_framework/common/progress/upload_image_list_progress.dart';
import 'package:flutter_framework/common/protocol/admin/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/oss/remove_list_of_object_file.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/oss.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/oss/fetch_header_list_of_object_file_list_of_advertisement.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_framework/dashboard/local/image_item.dart';

Future<int> showUpdateRecordOfAdvertisementProgressDialog(
  BuildContext context, {
  required int advertisementId,
  required String name,
  required String title,
  required int sellingPrice,
  required int status,
  required List<String> sellingPoints,
  required String placeOfOrigin,
  required int stock,
  required int productId,
  required Map<String, ImageItem> imageMap,
  required Map<String, ImageItem> oriImageMap,
  required String image,
  required String commonPath,
}) async {
  var result = Code.internalError;
  bool closed = false;
  int curStage = 0;
  var ossHost = '';
  var from = 'showUpdateRecordOfAdvertisementProgressDialog';
  List<String> nameListOfFile = []; // object file to be uploaded
  var oriObserve = Runtime.getObserve();
  Map<String, ObjectFileRequestHeader> requestHeader = {}; // key: object file name
  List<String> objectFileToBeRemoved = [];

  String information = '';
  double height = 100;
  double width = 200;
  Map<String, Uint8List> objectDataMapping = {}; // key: object file name, value: native file data

  bool hasFigureOutStep1Argument = false;
  bool hasFigureOutStep2Argument = false;
  bool hasFigureOutStep3Argument = false;
  bool hasFigureOutStep4Argument = false;

  var step1 = FetchHeaderListOfObjectFileListOfAdvertisementProgress.construct(
    result: -1,
    advertisementId: 0, // later
    nameListOfFile: nameListOfFile, // later
  );

  var step2 = UploadImageListProgress.construct(
    result: -2,
    ossHost: '', // later
    requestHeader: {}, // later
    objectDataMapping: {}, // later
  );

  var step3 = UpgradeFieldsOfAdvertisementProgress.construct(
    result: -3,
    id: advertisementId,
    image: '',
    // later
    name: name,
    title: title,
    stock: stock,
    status: status,
    productId: productId,
    sellingPrice: sellingPrice,
    sellingPoints: sellingPoints,
    placeOfOrigin: placeOfOrigin,
  );

  var step4 = RemoveListOfObjectFileProgress.construct();

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

  fetchHeaderListOfObjectFileListOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchHeaderListOfObjectFileListOfAdvertisementHandler';
    try {
      var rsp = FetchHeaderListOfObjectFileListOfAdvertisementRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: '',
      );
      if (rsp.getCode() == Code.oK) {
        rsp.getRequestHeader().forEach((key, value) {
          requestHeader[key] = value;
        });
        ossHost = rsp.getHost();
        print('ossHost: $ossHost');
        requestHeader.forEach((key, value) {
          print('file: $key, value: ${value.toString()}');
          if (objectDataMapping.containsKey(key)) {
            print('size: ${objectDataMapping[key]!.length}');
          }
        });
        commonPath = rsp.getCommonPath();
        step1.respond(rsp);
      } else {
        // error occurs
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

  void updateRecordOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'updateRecordOfAdvertisementHandler';
    try {
      var rsp = UpdateRecordOfAdvertisementRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      step3.respond(rsp);
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
    } finally {}
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
      step4.respond(rsp);
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
    } finally {}
  }

  void figureOutNameListOfFile() {
    try {
      imageMap.forEach(
        (key, value) {
          if (imageMap[key]!.getNative()) {
            // to be uploaded condition
            nameListOfFile.add(imageMap[key]!.getObjectFile());
            objectDataMapping[imageMap[key]!.getObjectFile()] = value.getData();

            // to be removed condition
            if (oriImageMap.containsKey(key)) {
              if (oriImageMap[key]!.getObjectFile().compareTo(imageMap[key]!.getObjectFile()) != 0) {
                objectFileToBeRemoved.add(oriImageMap[key]!.getObjectFile());
              }
            }
          }
        },
      );
      oriImageMap.forEach(
        (key, value) {
          if (!imageMap.containsKey(key)) {
            // to be removed condition
            objectFileToBeRemoved.add(oriImageMap[key]!.getObjectFile());
          }
        },
      );
    } catch (e) {
      print('$from failure: $e');
    } finally {
      // thumbnail
      print('$objectFileToBeRemoved to be removed');
      print('$nameListOfFile to be uploaded');
      objectDataMapping.forEach((key, value) {
        print("object file: $key, length: ${value.length}");
      });
    }
  }

  void figureOutProgress() {
    if (nameListOfFile.isEmpty) {
      // skip fetch header and upload image progress
      step1.skip();
      step2.skip();
    }
    if (objectFileToBeRemoved.isEmpty) {
      step4.skip();
    }
  }

  void progress() {
    if (!hasFigureOutStep1Argument) {
      step1.setAdvertisementId(advertisementId);
      step1.setNameListOfFile(nameListOfFile);
      hasFigureOutStep1Argument = true;
    }

    step1.progress();
    if (!step1.finished()) {
      return;
    }

    if (step1.result() < 0) {
      result = step1.result();
      Navigator.pop(context);
      return;
    }

    if (!hasFigureOutStep2Argument) {
      step2.setOSSHost(ossHost);
      step2.setObjectDataMapping(objectDataMapping);
      step2.setRequestHeader(requestHeader);
      hasFigureOutStep2Argument = true;
    }

    step2.progress();
    if (!step2.finished()) {
      return;
    }

    if (step2.result() < 0) {
      result = step2.result();
      Navigator.pop(context);
      return;
    }

    if (!hasFigureOutStep3Argument) {
      var imageOfAdvertisement = () {
        String output = '';
        Map<String, String> temp = {};
        imageMap.forEach(
          (key, value) {
            temp[value.getDBKey()] = commonPath + value.getObjectFile();
          },
        );
        output = jsonEncode(temp);
        return output;
      }();
      step3.setImage(imageOfAdvertisement);
      hasFigureOutStep3Argument = true;
    }

    step3.progress();
    if (!step3.finished()) {
      return;
    }

    if (step3.result() < 0) {
      result = step3.result();
      Navigator.pop(context);
      return;
    }

    if (!hasFigureOutStep4Argument) {
      step4.setObjectFileToBeRemoved(objectFileToBeRemoved);
      hasFigureOutStep4Argument = true;
    }

    var ret = step4.progress();
    if (ret > 0) {
      return;
    }

    if (ret < 0) {
      result = -4;
      Navigator.pop(context);
      return;
    }

    result = 0;
    Navigator.pop(context);
    return;
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
      if (major == Major.oss && minor == OSS.fetchHeaderListOfObjectFileListOfAdvertisementRsp) {
        fetchHeaderListOfObjectFileListOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.updateRecordOfAdvertisementRsp) {
        updateRecordOfAdvertisementHandler(major: major, minor: minor, body: body);
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
    } finally {}
  }

  void setup() {
    print('Original Image map: ');
    oriImageMap.forEach(
      (key, value) {
        print('key: $key, dbKey: ${value.getDBKey()}, objectFile: ${value.getObjectFile()}, url: ${value.getUrl()}');
      },
    );
    print('Image map: ');
    imageMap.forEach(
      (key, value) {
        print('key: $key, dbKey: ${value.getDBKey()}, objectFile: ${value.getObjectFile()}, url: ${value.getUrl()}');
      },
    );
    figureOutNameListOfFile();
    figureOutProgress();
    Runtime.setObserve(observe);
    Runtime.setPeriod(Config.periodOfScreenInitialisation);
    Runtime.setPeriodic(progress);
  }

  setup();

  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Translator.translate(Language.modifyAdvertisement)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Translator.translate(Language.cancel)),
          ),
        ],
        content: StreamBuilder(
          stream: stream(),
          builder: (context, snap) {
            return SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(information),
                    const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
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
      Runtime.setPeriod(Config.periodOfScreenNormal);
      Runtime.setPeriodic(null);
      return result;
    },
  );
}
