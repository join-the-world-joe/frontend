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
import 'package:flutter_framework/common/protocol/oss/remove_list_of_object_file.dart';
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
import 'package:flutter_framework/dashboard/local/image_item.dart';
import 'package:flutter_framework/common/business/oss/remove_list_of_object_file.dart';

/*
work flow
fetch oss headers    ------->  backend
oss request headers  <-------  backend
upload images        ------->  oss server
http status code     <-------  oss server
upgrade image field  ------->  backend
result               <-------  backend
remove object file   ------->  backend
result               <-------  backend
verify oss objects   ------->  backend
result               <-------  backend
four possible stage; requested, timeout(after interval), responded, failure(successfully)
 */

Future<int> showUpdateAdvertisementProgressDialog(
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
  required String thumbnailKey,
  required String image,
  required String commonPath,
}) async {
  var result = Code.internalError;
  bool closed = false;
  int curStage = 0;
  var ossHost = '';
  var from = 'showUpdateAdvertisementProgressDialog';
  List<String> nameListOfFile = []; // object file to be uploaded
  var oriObserve = Runtime.getObserve();
  Map<String, ObjectFileRequestHeader> requestHeader = {}; // key: object file name
  List<String> objectFileTobeRemoved = [];

  // fetch header
  bool fetchHeaderRequested = false;
  bool fetchHeaderResponded = false;
  DateTime? fetchHeaderRequestTime;
  bool fetchHeaderSuccessfully = false;
  // upload image list
  int uploadedImageCount = 0;
  int totalImageCount = 10;
  bool uploadImageListRequested = false;
  bool uploadImageListResponded = false;
  DateTime? uploadImageListRequestTime;
  bool uploadImageListSuccessfully = false;
  // upgrade fields field
  bool upgradeFieldsOfAdvertisementRequested = false;
  bool upgradeFieldsOfAdvertisementResponded = false;
  DateTime? upgradeFieldsOfAdvertisementRequestTime;
  bool upgradeFieldsOfAdvertisementSuccessfully = false;
  // remove list of object file
  bool removeListOfObjectFileRequested = false;

  String information = '';
  double height = 100;
  double width = 200;
  Map<String, Uint8List> objectDataMapping = {}; // key: object file name, value: native file data

  Stream<int>? yeildData() async* {
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
        // print('ossHost: $ossHost');
        // requestHeader.forEach((key, value) {
        //   print('file: $key, value: ${value.toString()}');
        //   if (objectDataMapping.containsKey(key)) {
        //     print('size: ${objectDataMapping[key]!.length}');
        //   }
        // });
        commonPath = rsp.getCommonPath();
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
        upgradeFieldsOfAdvertisementSuccessfully = true;
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
      upgradeFieldsOfAdvertisementResponded = true;
    }
  }

  void removeListOfObjectFileHandler({required String major, required String minor, required Map<String, dynamic> body}) {
    var caller = 'removeListOfObjectFileHandler';
    try {
      RemoveListOfObjectFileRsp rsp = RemoveListOfObjectFileRsp.fromJson(body);
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
                objectFileTobeRemoved.add(oriImageMap[key]!.getObjectFile());
              }
            }
          }
        },
      );
      oriImageMap.forEach(
        (key, value) {
          if (!imageMap.containsKey(key)) {
            // to be removed condition
            objectFileTobeRemoved.add(oriImageMap[key]!.getObjectFile());
          }
        },
      );
      totalImageCount = nameListOfFile.length;
    } catch (e) {
      print('$from failure: $e');
    } finally {
      // thumbnail
      print('$objectFileTobeRemoved to be removed');
      print('$nameListOfFile to be uploaded');
      objectDataMapping.forEach((key, value) {
        print("object file: $key, length: ${value.length}");
      });

      if (nameListOfFile.isEmpty && objectFileTobeRemoved.isEmpty) {
        uploadImageListSuccessfully = true;
        uploadImageListResponded = true;
      }
    }
  }

  void figureOutProgress() {
    if (nameListOfFile.isEmpty) {
      // skip fetch header and upload image progress
      fetchHeaderResponded = true;
      fetchHeaderSuccessfully = true;
      uploadImageListResponded = true;
      uploadImageListSuccessfully = true;
    }
    if (objectFileTobeRemoved.isEmpty) {
      // skip remove object file progress
      removeListOfObjectFileRequested = true;
    }
  }

  void removeListOfObjectFileProgress() {
    var caller = 'removeListOfObjectFile';
    if (!removeListOfObjectFileRequested) {
      removeListOfObjectFile(
        from: from,
        caller: caller,
        listOfObjectFile: objectFileTobeRemoved,
      );
    }
    removeListOfObjectFileRequested = true;
  }

  int uploadImageListProgress() {
    var caller = 'uploadImageListProgress';
    if (uploadImageListSuccessfully) {
      // print('uploadImageListProgress finished');
      return 0;
    }
    // check state of request
    if (!uploadImageListRequested && fetchHeaderSuccessfully) {
      if (nameListOfFile.isNotEmpty) {
        for (var object in nameListOfFile) {
          // print('object: $object');
          if (objectDataMapping.containsKey(object)) {
            // print('length: ${objectDataMapping[object]!.length}');
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
      return -2;
    }
    // update progress
    if (uploadImageListRequested && uploadImageListResponded && !uploadImageListSuccessfully) {
      if (uploadedImageCount == totalImageCount) {
        uploadImageListSuccessfully = true;
      }
    }
    // check state of failure
    // if (uploadImageListResponded && !uploadImageListSuccessfully) {
    //   return -2;
    // }
    return 0; // middle state; requested --state-- responded
  }

  int fetchHeaderProgress() {
    var caller = 'fetchHeaderProgress';
    if (fetchHeaderSuccessfully) {
      // print('fetchHeaderProgress finished');
      return 0;
    }
    // check state of request
    if (!fetchHeaderRequested) {
      fetchHeaderListOfObjectFileListOfAdvertisement(
        from: from,
        caller: caller,
        advertisementId: 1,
        nameListOfFile: nameListOfFile,
      );
      fetchHeaderRequested = true;
      fetchHeaderRequestTime = DateTime.now();
    }
    // check state of timeout
    if (fetchHeaderRequested && !fetchHeaderResponded && DateTime.now().isAfter(fetchHeaderRequestTime!.add(Config.httpDefaultTimeout))) {
      return -1;
    }
    // check state of failure
    if (fetchHeaderResponded && !fetchHeaderSuccessfully) {
      return -1;
    }
    return 0; // middle state; requested --state-- responded
  }

  int upgradeFieldsOfAdvertisementProgress() {
    var caller = 'upgradeFieldsOfAdvertisementProgress';
    if (upgradeFieldsOfAdvertisementSuccessfully) {
      print('upgradeFieldsOfAdvertisementProgress finished');
      return 0;
    }
    // check state of request
    if (!upgradeFieldsOfAdvertisementRequested && uploadImageListSuccessfully) {
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
      print('imageOfAdvertisement: $imageOfAdvertisement');
      updateRecordOfAdvertisement(
        from: from,
        caller: caller,
        id: advertisementId,
        image: imageOfAdvertisement,
        name: name,
        title: title,
        stock: stock,
        status: status,
        productId: productId,
        sellingPrice: sellingPrice,
        sellingPoints: sellingPoints,
        placeOfOrigin: placeOfOrigin,
      );
      upgradeFieldsOfAdvertisementRequested = true;
      upgradeFieldsOfAdvertisementRequestTime = DateTime.now();
    }
    // check state of timeout
    if (upgradeFieldsOfAdvertisementRequested && !upgradeFieldsOfAdvertisementResponded && DateTime.now().isAfter(upgradeFieldsOfAdvertisementRequestTime!.add(Config.httpDefaultTimeout))) {
      return -3;
    }
    // check state of failure
    if (upgradeFieldsOfAdvertisementResponded && !upgradeFieldsOfAdvertisementSuccessfully) {
      return -3;
    }
    return 0; // middle state; requested --state-- responded
  }

  void progress() {
    var caller = 'progress';
    if (upgradeFieldsOfAdvertisementSuccessfully) {
      result = 0; // success
      Navigator.pop(context);
      return;
    }

    result = fetchHeaderProgress(); // step 1
    if (result != Code.oK) {
      Navigator.pop(context);
      return;
    }
    result = uploadImageListProgress(); // step 2
    if (result != Code.oK) {
      Navigator.pop(context);
      return;
    }
    result = upgradeFieldsOfAdvertisementProgress(); // step 3
    if (result != Code.oK) {
      Navigator.pop(context);
      return;
    }

    removeListOfObjectFileProgress(); // step 4
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
        title: Text(Translator.translate(Language.fillSellingPoint)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(Translator.translate(Language.cancel)),
          ),
        ],
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
