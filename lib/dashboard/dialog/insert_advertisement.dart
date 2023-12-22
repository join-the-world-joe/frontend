import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_framework/common/business/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/business/admin/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/business/oss/fetch_header_list_of_object_file_list_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
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
four possible stage; requested, timeout(after interval), responded, failure(successfully)
 */

Future<int> showInsertAdvertisementDialog(
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
  var from = 'showInsertAdvertisementDialog';
  List<String> nameListOfFile = [];
  var oriObserve = Runtime.getObserve();
  Map<String, ObjectFileRequestHeader> requestHeader = {}; // key: object file name
  // insert advertisement
  bool insertAdvertisementRequested = false;
  bool insertAdvertisementResponded = false;
  DateTime? insertAdvertisementRequestTime;
  bool insertAdvertisementSuccessfully = false;
  // fetch header
  bool fetchHeaderRequested = false;
  bool fetchHeaderResponded = false;
  DateTime? fetchHeaderRequestTime;
  bool fetchHeaderSuccessfully = false;
  // upload image list
  int uploadedImageCount = 0;
  int totalImageCount = imageMap.length;
  bool uploadImageListRequested = false;
  bool uploadImageListResponded = false;
  DateTime? uploadImageListRequestTime;
  bool uploadImageListSuccessfully = false;
  // upgrade image field
  bool upgradeImageFieldRequested = false;
  bool upgradeImageFieldResponded = false;
  DateTime? upgradeImageFieldRequestTime;
  bool upgradeImageFieldSuccessfully = false;

  String defaultImage = '';
  String information = '';
  double height = 400;
  double width = 400;
  Map<String, Uint8List> objectDataMapping = {}; // key: object file name, value: native file name
  bool finished = false;

  Stream<int>? yeildData() async* {
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
      InsertRecordOfAdvertisementRsp rsp = InsertRecordOfAdvertisementRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}, advertisementId: ${rsp.getAdvertisementId()}',
      );
      if (rsp.getCode() == Code.oK) {
        advertisementId = rsp.getAdvertisementId();
        insertAdvertisementSuccessfully = true;
        return;
      } else {
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
    } finally {
      insertAdvertisementResponded = true;
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
        requestHeader.forEach((key, value) {
          print('file: $key, value: ${value.toString()}');
          if (objectDataMapping.containsKey(key)) {
            print('size: ${objectDataMapping[key]!.length}');
          }
        });
        commonOSSPath = rsp.getCommonPath();
        fetchHeaderSuccessfully = true;
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
    } finally {
      fetchHeaderResponded = true;
    }
  }

  void updateRecordOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'updateRecordOfAdvertisementHandler';
    try {
      UpdateRecordOfAdvertisementRsp rsp = UpdateRecordOfAdvertisementRsp.fromJson(body);
      Log.debug(
        major: major,
        minor: minor,
        from: from,
        caller: caller,
        message: 'code: ${rsp.getCode()}',
      );
      if (rsp.getCode() == Code.oK) {
        upgradeImageFieldSuccessfully = true;
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
    } finally {
      upgradeImageFieldResponded = true;
    }
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

  int insertAdvertisementProcess() {
    var caller = 'insertAdvertisementProcess';
    if (insertAdvertisementResponded && insertAdvertisementSuccessfully) {
      // print('insertAdvertisementProcess finished');
      return 0;
    }
    // check state of request
    if (!insertAdvertisementRequested) {
      insertRecordOfAdvertisement(
        from: from,
        caller: caller,
        name: name,
        title: title,
        sellingPrice: sellingPrice,
        sellingPoints: sellingPoints,
        image: defaultImage,
        placeOfOrigin: placeOfOrigin,
        stock: stock,
        productId: productId,
      );
      insertAdvertisementRequested = true;
      insertAdvertisementRequestTime = DateTime.now();
    }
    // check state of timeout
    if (insertAdvertisementRequested && !insertAdvertisementResponded && DateTime.now().isAfter(insertAdvertisementRequestTime!.add(Config.httpDefaultTimeout))) {
      return -1;
    }
    // check state of failure
    if (insertAdvertisementResponded && !insertAdvertisementSuccessfully) {
      return -1;
    }
    return 0; // middle state; requested --state-- responded
  }

  int uploadImageListProgress() {
    var caller = 'uploadImageListProgress';
    if (uploadImageListResponded && uploadImageListSuccessfully) {
      // print('uploadImageListProgress finished');
      return 0;
    }
    // check state of request
    if (!uploadImageListRequested && fetchHeaderSuccessfully) {
      if (nameListOfFile.isNotEmpty) {
        for (var object in nameListOfFile) {
          print('object: $object');
          if (objectDataMapping.containsKey(object)) {
            print('length: ${objectDataMapping[object]!.length}');
            API
                .put(
              scheme: 'https://',
              host: ossHost,
              port: '',
              endpoint: object,
              timeout: Config.httpDefaultTimeout,
              header: {
                "Authorization": requestHeader[object]!.getAuthorization(),
                "Content-Type": requestHeader[object]!.getContentType(),
                "Date": requestHeader[object]!.getDate(),
                "x-oss-date": requestHeader[object]!.getXOssDate(),
              },
              body: objectDataMapping[object]!,
            )
                .then((value) {
              if (value.getCode() == Code.oK) {
                uploadedImageCount++;
              }
              uploadImageListResponded = true;
            });
          }
        }
      } else {
        print('nameListOfFile is empty');
      }
      uploadImageListRequested = true;
      uploadImageListRequestTime = DateTime.now();
    }
    // check state of timeout
    if (uploadImageListRequested && !uploadImageListResponded && DateTime.now().isAfter(uploadImageListRequestTime!.add(Duration(seconds: Config.httpDefaultTimeoutInSecond * totalImageCount)))) {
      return -3;
    }
    // update progress
    if (uploadImageListRequested && uploadImageListResponded && !uploadImageListSuccessfully) {
      if (uploadedImageCount == totalImageCount) {
        uploadImageListSuccessfully = true;
      }
    }
    // check state of failure
    // if (uploadImageListResponded && !uploadImageListSuccessfully) {
    //   return -3;
    // }
    return 0; // middle state; requested --state-- responded
  }

  int fetchHeaderProgress() {
    var caller = 'fetchHeaderProgress';
    if (fetchHeaderResponded && fetchHeaderSuccessfully) {
      // print('fetchHeaderProgress finished');
      return 0;
    }
    // check state of request
    if (!fetchHeaderRequested && insertAdvertisementSuccessfully) {
      figureOutNameListOfFile();
      fetchHeaderListOfObjectFileListOfAdvertisement(
        from: from,
        caller: caller,
        advertisementId: advertisementId!,
        nameListOfFile: nameListOfFile,
      );
      fetchHeaderRequested = true;
      fetchHeaderRequestTime = DateTime.now();
    }
    // check state of timeout
    if (fetchHeaderRequested && !fetchHeaderResponded && DateTime.now().isAfter(fetchHeaderRequestTime!.add(Config.httpDefaultTimeout))) {
      return -2;
    }
    // check state of failure
    if (fetchHeaderResponded && !fetchHeaderSuccessfully) {
      return -2;
    }
    return 0; // middle state; requested --state-- responded
  }

  int upgradeImageFieldProgress() {
    var caller = 'upgradeImageFieldProgress';
    if (upgradeImageFieldResponded && upgradeImageFieldSuccessfully) {
      print('upgradeImageFieldProgress finished');
      return 0;
    }
    // check state of request
    if (!upgradeImageFieldRequested && uploadImageListSuccessfully) {
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
      updateRecordOfAdvertisement(
        from: from,
        caller: caller,
        id: advertisementId!,
        image: image,
        name: name,
        title: title,
        stock: stock,
        status: 1,
        productId: productId,
        sellingPrice: sellingPrice,
        sellingPoints: sellingPoints,
        placeOfOrigin: placeOfOrigin,
      );
      upgradeImageFieldRequested = true;
      upgradeImageFieldRequestTime = DateTime.now();
    }
    // check state of timeout
    if (upgradeImageFieldRequested && !upgradeImageFieldResponded && DateTime.now().isAfter(upgradeImageFieldRequestTime!.add(Config.httpDefaultTimeout))) {
      return -4;
    }
    // check state of failure
    if (upgradeImageFieldResponded && !upgradeImageFieldSuccessfully) {
      return -4;
    }
    return 0; // middle state; requested --state-- responded
  }

  void progress() {
    var caller = 'progress';
    if (upgradeImageFieldSuccessfully) {
      result = 0; // success
      Navigator.pop(context);
      return;
    }
    result = insertAdvertisementProcess(); // step 1
    if (result != Code.oK) {
      Navigator.pop(context);
      return;
    }
    result = fetchHeaderProgress(); // step 2
    if (result != Code.oK) {
      Navigator.pop(context);
      return;
    }
    result = uploadImageListProgress(); // step 3
    if (result != Code.oK) {
      Navigator.pop(context);
      return;
    }
    result = upgradeImageFieldProgress(); // step 4
    if (result != Code.oK) {
      Navigator.pop(context);
      return;
    }
    // if (uploadThumbnailCompleted) {
    //   print('upload thumbnail success');
    //   Runtime.setPeriod(Config.periodOfScreenNormal);
    //   Runtime.setPeriodic(null);
    //   Navigator.pop(context);
    //   finished = true;
    //   return;
    // }

    // if (!uploadImageRequested && insertAdvertisementRequestCompleted && fetchHeaderRequestCompleted) {
    //   if (imageMap[thumbnailKey] != null) {
    //     API
    //         .put(
    //       scheme: 'https://',
    //       host: ossHost,
    //       port: '',
    //       endpoint: nameListOfFile[0],
    //       timeout: Duration(minutes: 1),
    //       header: {
    //         "Authorization": requestHeader[nameListOfFile[0]]!.getAuthorization(),
    //         "Content-Type": requestHeader[nameListOfFile[0]]!.getContentType(),
    //         "Date": requestHeader[nameListOfFile[0]]!.getDate(),
    //         "x-oss-date": requestHeader[nameListOfFile[0]]!.getXOssDate(),
    //       },
    //       body: imageMap[thumbnailKey]!.data!,
    //     )
    //         .then((value) {
    //       if (value.getCode() == Code.oK) {
    //         uploadThumbnailCompleted = true;
    //       }
    //     });
    //     uploadImageRequested = true;
    //   }
    // }
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
        title: Text(Translator.translate(Language.fillSellingPoint)),
        actions: [],
        content: StreamBuilder(
          stream: yeildData(),
          builder: (context, snap) {
            return SizedBox(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(information),
                    const SizedBox(
                      width: 100,
                      height: 200,
                      child: CircularProgressIndicator(),
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
