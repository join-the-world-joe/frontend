import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/business/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/business/admin/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/business/oss/fetch_header_list_of_object_file_list_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/progress/fetch_header_list_of_object_file_list_of_advertisement_progress.dart';
import 'package:flutter_framework/common/progress/insert_record_of_advertisement_progress.dart';
import 'package:flutter_framework/common/progress/upgrade_fields_of_advertisement_progress.dart';
import 'package:flutter_framework/common/progress/upload_image_list_progress.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/admin/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/common/route/oss.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/api.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../config/config.dart';
import 'package:flutter_framework/common/protocol/oss/fetch_header_list_of_object_file_list_of_advertisement.dart';
import 'package:path/path.dart' as path;

/*
work flow
insert advertisement ------->  backend
advertisement id     <-------  backend
fetch oss headers    ------->  backend
oss request headers  <-------  backend
upload images        ------->  oss server
http status code     <-------  oss server
upgrade image field  ------->  backend
result               <-------  backend
verify oss objects   ------->  backend
result               <-------  backend
 */

Future<int> showInsertRecordOfAdvertisementProgressDialog(
  BuildContext context, {
  required String name,
  required String title,
  required int sellingPrice,
  required List<String> sellingPoints,
  required String placeOfOrigin,
  required int stock,
  required int productId,
  required Map<String, MediaInfo> imageMap,
  required List<String> imageList,
  required String thumbnailKey,
}) async {
  var result = Code.internalError;
  int? advertisementId;
  bool closed = false;
  int curStage = 0;
  var ossHost = '';
  var commonOSSPath = '';
  var from = 'showInsertRecordOfAdvertisementProgressDialog';
  List<String> nameListOfFile = [];
  var oriObserve = Runtime.getObserve();
  Map<String, ObjectFileRequestHeader> requestHeader = {}; // key: object file name

  String defaultImage = '';
  String information = '';
  double height = 100;
  double width = 200;
  Map<String, Uint8List> objectDataMapping = {}; // key: object file name, value: native file name
  bool hasFigureOutNameListOfFile = false;
  bool hasFigureOutStep3Argument = false;
  bool hasFigureOutStep4Argument = false;

  var step1 = InsertRecordOfAdvertisementProgress.construct(
    result: -1,
    record: Advertisement.construct(
      id: 0,
      name: name,
      title: title,
      placeOfOrigin: placeOfOrigin,
      sellingPoints: sellingPoints,
      image: defaultImage,
      sellingPrice: sellingPrice,
      stock: stock,
      status: 0,
      productId: productId,
    ),
  );

  var step2 = FetchHeaderListOfObjectFileListOfAdvertisementProgress.construct(
    result: -2,
    advertisementId: 0,
    nameListOfFile: nameListOfFile,
  );

  var step3 = UploadImageListProgress.construct(
    result: -3,
    ossHost: '',
    requestHeader: {},
    objectDataMapping: {},
  );

  var step4 = UpgradeFieldsOfAdvertisementProgress.construct(
    result: -4,
    id: -1,
    image: '',
    name: name,
    title: title,
    stock: stock,
    status: 1,
    productId: productId,
    sellingPrice: sellingPrice,
    sellingPoints: sellingPoints,
    placeOfOrigin: placeOfOrigin,
  );

  Stream<int>? stream() async* {
    var lastStage = curStage;
    while (!closed) {
      await Future.delayed(Config.checkStageIntervalNormal);
      // print('showFillSellingPointDialog, last: $lastStage, cur: $curStage');
      if (lastStage != curStage) {
        lastStage = curStage;
        yield lastStage;
      }
    }
  }

  void insertRecordOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'insertRecordOfAdvertisementHandler';
    try {
      var rsp = InsertRecordOfAdvertisementRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}, advertisementId: ${rsp.getAdvertisementId()}',
      );
      advertisementId = rsp.getAdvertisementId();
      step1.respond(rsp);
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

  fetchHeaderListOfObjectFileListOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'fetchHeaderListOfObjectFileListOfAdvertisementHandler';
    try {
      FetchHeaderListOfObjectFileListOfAdvertisementRsp rsp = FetchHeaderListOfObjectFileListOfAdvertisementRsp.fromJson(body);
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
        requestHeader.forEach(
          (key, value) {
            print('file: $key, value: ${value.toString()}');
            if (objectDataMapping.containsKey(key)) {
              print('size: ${objectDataMapping[key]!.length}');
            }
          },
        );
        commonOSSPath = rsp.getCommonPath();
        step2.respond(rsp);
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
    String extension = path.extension(imageMap[thumbnailKey]!.fileName!).toLowerCase();
    nameListOfFile.add('$advertisementId/0$extension');
    objectDataMapping['$advertisementId/0$extension'] = imageMap[thumbnailKey]!.data!;
    for (var index = 0; index < imageList.length; index++) {
      extension = path.extension(imageMap[imageList[index]]!.fileName!).toLowerCase();
      nameListOfFile.add('$advertisementId/${index + 1}$extension');
      objectDataMapping['$advertisementId/${index + 1}$extension'] = imageMap[imageList[index]]!.data!;
    }
    print('nameList: $nameListOfFile');
  }

  void progress() {
    var caller = 'progress';

    step1.progress();
    if (!step1.finished()) {
      return;
    }

    if (step1.result() < 0) {
      result = step1.result();
      Navigator.pop(context);
      return;
    }

    if (!hasFigureOutNameListOfFile && step1.result() == 0) {
      figureOutNameListOfFile();
      step2.setAdvertisementId(advertisementId!);
      hasFigureOutNameListOfFile = true;
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
      step3.setObjectDataMapping(objectDataMapping);
      step3.setOSSHost(ossHost);
      step3.setRequestHeader(requestHeader);
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
      var image = () {
        String output = '';
        try {
          Map<String, String> temp = {};
          for (var e in nameListOfFile) {
            var key = ((e.split('.')[0]).split('/'))[1];
            temp[key] = commonOSSPath + e;
          }
          output = jsonEncode(temp);
          print('output: $output');
        } catch (e) {
          print('upgradeImageFieldProgress failure, err: $e');
        }
        return output;
      }();
      step4.setAdvertisementId(advertisementId!);
      step4.setImage(image);
      hasFigureOutStep4Argument = true;
    }

    step4.progress();
    if (!step4.finished()) {
      return;
    }

    if (step4.result() < 0) {
      result = step4.result();
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
      } else if (major == Major.admin && minor == Admin.insertRecordOfAdvertisementRsp) {
        insertRecordOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.updateRecordOfAdvertisementRsp) {
        updateRecordOfAdvertisementHandler(major: major, minor: minor, body: body);
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
        title: Text(Translator.translate(Language.operationToInsertAdvertisement)),
        actions: [],
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
