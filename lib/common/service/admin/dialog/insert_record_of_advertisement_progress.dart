import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/progress/fetch_header_list_of_object_file_list_progress.dart';
import 'package:flutter_framework/common/progress/insert_record_of_advertisement_progress.dart';
import 'package:flutter_framework/common/progress/upgrade_fields_of_advertisement_progress.dart';
import 'package:flutter_framework/common/progress/upload_image_list_progress.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/oss.dart';
import 'package:flutter_framework/common/service/admin/protocol/update_record_of_advertisement.dart';
import 'package:flutter_framework/common/service/advertisement/protocol/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/service/oss/progress/fetch_header_list_of_object_file_list/fetch_header_list_of_object_file_list_step.dart';
import 'package:flutter_framework/common/service/oss/protocol/fetch_header_list_of_object_file_list.dart';
import 'package:flutter_framework/dashboard/local/image_item.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:image_picker_web/image_picker_web.dart';
import '../../../../dashboard/config/config.dart';
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

Future<int> showInsertRecordOfAdvertisementProgressDialog(BuildContext context,
    {required String name,
    required String title,
    required int sellingPrice,
    required List<String> sellingPoints,
    required String placeOfOrigin,
    required int stock,
    required int productId,
    required String ossFolder,
    required ImageItem? coverImage,
    required ImageItem? firstImage,
    required ImageItem? secondImage,
    required ImageItem? thirdImage,
    required ImageItem? fourthImage,
    required ImageItem? fifthImage}) async {
  var result = Code.internalError;
  bool closed = false;
  int curStage = 0;
  var ossHost = '';
  var commonOSSPath = '';
  var from = 'showInsertRecordOfAdvertisementProgressDialog';
  List<String> nameListOfFile = [];
  var oriObserve = Runtime.getObserve();
  Map<String, ObjectFileRequestHeader> requestHeader = {}; // key: object file name
  String information = '';
  double height = 100;
  double width = 200;
  Map<String, Uint8List> objectDataMapping = {}; // key: object file name, value: native file name
  bool hasFigureOutNameListOfFile = false;
  bool hasFigureOutStep2Argument = false;
  bool hasFigureOutStep4Argument = false;

  bool hasFigureOutHeaderListArgument = false;
  bool hasFigureOutUploadImageArgument = false;
  FetchHeaderListOfObjectFileListProgress? fetchHeaderListOfObjectFileListProgress;
  UploadImageListProgress? uploadImageListProgress;

  String genImageField(ImageItem item) {
    var output = '';
    try {
      Map<String, String> temp = {};
      temp['width'] = item.getWidth().toString();
      temp['height'] = item.getHeight().toString();
      temp['object_file_name'] = item.getObjectFileName();
      output = jsonEncode(temp);
    } catch (e) {
      print('genImageField failure, e: $e');
    }
    return output;
  }

  var step1 = FetchHeaderListOfObjectFileListProgress.construct(
    result: -2,
    ossFolder: ossFolder,
    nameListOfFile: nameListOfFile,
  );

  var step2 = InsertRecordOfAdvertisementProgress.construct(
    result: -1,
    record: Advertisement.construct(
      id: 0,
      name: name,
      title: title,
      placeOfOrigin: placeOfOrigin,
      sellingPoints: sellingPoints,
      coverImage: coverImage == null ? '' : genImageField(coverImage),
      firstImage: firstImage == null ? '' : genImageField(firstImage),
      secondImage: secondImage == null ? '' : genImageField(secondImage),
      thirdImage: thirdImage == null ? '' : genImageField(thirdImage),
      fourthImage: fourthImage == null ? '' : genImageField(fourthImage),
      fifthImage: fifthImage == null ? '' : genImageField(fifthImage),
      sellingPrice: sellingPrice,
      ossFolder: ossFolder,
      ossPath: '',
      stock: stock,
      status: 0,
      productId: productId,
    ),
  );

  var step3 = UploadImageListProgress.construct(
    result: -3,
    ossHost: '',
    requestHeader: requestHeader,
    objectDataMapping: objectDataMapping,
  );

  // var step4 = UpgradeFieldsOfAdvertisementProgress.construct(
  //   result: -4,
  //   id: -1,
  //   coverImage: defaultImage,
  //   firstImage: defaultImage,
  //   secondImage: defaultImage,
  //   thirdImage: defaultImage,
  //   fourthImage: defaultImage,
  //   fifthImage: defaultImage,
  //   name: name,
  //   title: title,
  //   stock: stock,
  //   status: 1,
  //   productId: productId,
  //   sellingPrice: sellingPrice,
  //   sellingPoints: sellingPoints,
  //   placeOfOrigin: placeOfOrigin,
  // );

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
      // advertisementId = rsp.getAdvertisementId();
      step2.respond(rsp);
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



  // void updateRecordOfAdvertisementHandler({required String major, required String minor, required Map<String, dynamic> body}) {
  //   var caller = 'updateRecordOfAdvertisementHandler';
  //   try {
  //     var rsp = UpdateRecordOfAdvertisementRsp.fromJson(body);
  //     Log.debug(
  //       major: major,
  //       minor: minor,
  //       from: from,
  //       caller: caller,
  //       message: 'code: ${rsp.getCode()}',
  //     );
  //     step4.respond(rsp);
  //     if (rsp.getCode() == Code.oK) {
  //       return;
  //     } else {
  //       // error occurs
  //       return;
  //     }
  //   } catch (e) {
  //     Log.debug(
  //       major: major,
  //       minor: minor,
  //       from: from,
  //       caller: caller,
  //       message: 'failure, err: $e',
  //     );
  //     return;
  //   } finally {}
  // }

  void figureOutNameListOfFile() {
    if (coverImage != null) {
      nameListOfFile.add(coverImage.getObjectFileName());
      objectDataMapping[coverImage.getObjectFileName()] = coverImage.getData();
    }
    if (firstImage != null) {
      nameListOfFile.add(firstImage.getObjectFileName());
      objectDataMapping[firstImage.getObjectFileName()] = firstImage.getData();
    }
    if (secondImage != null) {
      nameListOfFile.add(secondImage.getObjectFileName());
      objectDataMapping[secondImage.getObjectFileName()] = secondImage.getData();
    } else {
      return;
    }
    if (thirdImage != null) {
      nameListOfFile.add(thirdImage.getObjectFileName());
      objectDataMapping[thirdImage.getObjectFileName()] = thirdImage.getData();
    } else {
      return;
    }
    if (fourthImage != null) {
      nameListOfFile.add(fourthImage.getObjectFileName());
      objectDataMapping[fourthImage.getObjectFileName()] = fourthImage.getData();
    } else {
      return;
    }
    if (fifthImage != null) {
      nameListOfFile.add(fifthImage.getObjectFileName());
      objectDataMapping[fifthImage.getObjectFileName()] = fifthImage.getData();
    } else {
      return;
    }
  }

  void progress() {
    if (!hasFigureOutHeaderListArgument) {
      figureOutNameListOfFile();
      print('nameListOfFile: $nameListOfFile');
      fetchHeaderListOfObjectFileListProgress = FetchHeaderListOfObjectFileListProgress.construct(
        result: -1,
        ossFolder: ossFolder,
        nameListOfFile: nameListOfFile,
      );
      hasFigureOutHeaderListArgument = true;
    }

    // if (!hasFigureOutUploadImageArgument) {
    //   uploadImageListProgress = UploadImageListProgress.construct(
    //     result: result,
    //     ossHost: ossHost,
    //     requestHeader: requestHeader,
    //     objectDataMapping: objectDataMapping,
    //   );
    //   hasFigureOutUploadImageArgument = true;
    // }

    result = 0;
    Navigator.pop(context);
    // if (!hasFigureOutNameListOfFile) {
    //   figureOutNameListOfFile();
    //   print('nameList: $nameListOfFile');
    //   step1.setOSSFolder(ossFolder);
    //   hasFigureOutNameListOfFile = true;
    // }
    //
    // step1.progress();
    // if (!step1.finished()) {
    //   return;
    // }
    //
    // if (step1.result() < 0) {
    //   result = step1.result();
    //   Navigator.pop(context);
    //   return;
    // }
    //
    // if (!hasFigureOutStep2Argument) {
    //   step2.setOSSFolder(ossFolder);
    //   step2.setOSSPath(commonOSSPath);
    //   hasFigureOutStep2Argument = true;
    // }
    //
    // step2.progress();
    // if (!step2.finished()) {
    //   return;
    // }
    //
    // if (step2.result() < 0) {
    //   result = step2.result();
    //   Navigator.pop(context);
    //   return;
    // }

    // if (!hasFigureOutNameListOfFile && step1.finished()) {
    //   figureOutNameListOfFile();
    //   print('nameList: $nameListOfFile');
    //   step2.setOSSFolder(ossFolder);
    //   hasFigureOutNameListOfFile = true;
    // }

    // if (!hasFigureOutStep3Argument) {
    //   step3.setObjectDataMapping(objectDataMapping);
    //   step3.setOSSHost(ossHost);
    //   step3.setRequestHeader(requestHeader);
    //   hasFigureOutStep3Argument = true;
    // }
    //
    // step3.progress();
    // if (!step3.finished()) {
    //   return;
    // }

    // if (step3.result() < 0) {
    //   result = step3.result();
    //   Navigator.pop(context);
    //   return;
    // }
    //
    // if (!hasFigureOutStep4Argument) {
    //   if (coverImage != null) {
    //     coverImage.setUrl(commonOSSPath + '$ossFolder/' + coverImage.getObjectFileName());
    //     step4.setCoverImage(coverImage);
    //   }
    //   if (firstImage != null) {
    //     firstImage.setUrl(commonOSSPath + '$ossFolder/' + firstImage.getObjectFileName());
    //     step4.setFirstImage(firstImage);
    //   }
    //   if (firstImage != null && secondImage != null) {
    //     secondImage.setUrl(commonOSSPath + '$ossFolder/' + secondImage.getObjectFileName());
    //     step4.setSecondImage(secondImage);
    //   }
    //   if (firstImage != null && secondImage != null && thirdImage != null) {
    //     thirdImage.setUrl(commonOSSPath + '$ossFolder/' + thirdImage.getObjectFileName());
    //     step4.setThirdImage(thirdImage);
    //   }
    //   if (firstImage != null && secondImage != null && thirdImage != null && fourthImage != null) {
    //     fourthImage.setUrl(commonOSSPath + '$ossFolder/' + fourthImage.getObjectFileName());
    //     step4.setFourthImage(fourthImage);
    //   }
    //   if (firstImage != null && secondImage != null && thirdImage != null && fourthImage != null && fifthImage != null) {
    //     fifthImage.setUrl(commonOSSPath + '$ossFolder/' + fifthImage.getObjectFileName());
    //     step4.setFifthImage(fifthImage);
    //   }
    //
    //   step4.setAdvertisementId(advertisementId!);
    //
    //   hasFigureOutStep4Argument = true;
    // }
    //
    // step4.progress();
    // if (!step4.finished()) {
    //   return;
    // }
    //
    // if (step4.result() < 0) {
    //   result = step4.result();
    //   Navigator.pop(context);
    //   return;
    // }

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
        // fetchHeaderListOfObjectFileListOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.insertRecordOfAdvertisementRsp) {
        insertRecordOfAdvertisementHandler(major: major, minor: minor, body: body);
      } else if (major == Major.admin && minor == Admin.updateRecordOfAdvertisementRsp) {
        // updateRecordOfAdvertisementHandler(major: major, minor: minor, body: body);
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
