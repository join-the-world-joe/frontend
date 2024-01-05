import 'package:flutter/material.dart';
import 'package:flutter_framework/common/service/admin/progress/soft_delete_records_of_advertisement/soft_delete_records_of_advertisement_progress.dart';
import 'package:flutter_framework/common/service/admin/progress/soft_delete_records_of_advertisement/soft_delete_records_of_advertisement_step.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/dialog/message.dart';
import 'package:flutter_framework/common/service/oss/progress/remove_list_of_object_file/remove_list_of_object_file_progress.dart';
import 'package:flutter_framework/common/service/oss/progress/remove_list_of_object_file/remove_list_of_object_file_step.dart';
import 'package:flutter_framework/common/service/oss/protocol/remove_list_of_object_file.dart';
import 'package:flutter_framework/common/route/admin.dart';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/oss.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import 'package:flutter_framework/dashboard/dialog/warning.dart';
import 'package:flutter_framework/dashboard/local/image_item.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/log.dart';
import 'package:flutter_framework/utils/spacing.dart';
import '../../../../dashboard/config/config.dart';
import 'package:path/path.dart' as path;

Future<bool> showRemoveRecordOfAdvertisementDialog(BuildContext context, Advertisement advertisement) async {
  var oriObserve = Runtime.getObserve();
  double width = 220;
  double height = 150;
  bool closed = false;
  int curStage = 0;
  String from = 'showRemoveRecordOfAdvertisementDialog';
  List<String> objectFileList = [];

  SoftDeleteRecordsOfAdvertisementProgress? softDeleteRecordsOfAdvertisementProgress;
  RemoveListOfObjectFileProgress? removeListOfObjectFileProgress;

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

  void figureOutputObjectFileList() {
    objectFileList.clear();
    if (advertisement.getCoverImage().isNotEmpty) {
      var imageItem = ImageItem.fromRemote(advertisement.getCoverImage(), advertisement.getOSSPath());
      objectFileList.add(imageItem.getObjectFileName());
    }
    if (advertisement.getFirstImage().isNotEmpty) {
      var imageItem = ImageItem.fromRemote(advertisement.getFirstImage(), advertisement.getOSSPath());
      objectFileList.add(imageItem.getObjectFileName());
    }
    if (advertisement.getSecondImage().isNotEmpty) {
      var imageItem = ImageItem.fromRemote(advertisement.getSecondImage(), advertisement.getOSSPath());
      objectFileList.add(imageItem.getObjectFileName());
    }
    if (advertisement.getThirdImage().isNotEmpty) {
      var imageItem = ImageItem.fromRemote(advertisement.getThirdImage(), advertisement.getOSSPath());
      objectFileList.add(imageItem.getObjectFileName());
    }
    if (advertisement.getFourthImage().isNotEmpty) {
      var imageItem = ImageItem.fromRemote(advertisement.getFourthImage(), advertisement.getOSSPath());
      objectFileList.add(imageItem.getObjectFileName());
    }
    if (advertisement.getFifthImage().isNotEmpty) {
      var imageItem = ImageItem.fromRemote(advertisement.getFifthImage(), advertisement.getOSSPath());
      objectFileList.add(imageItem.getObjectFileName());
    }
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
      if (softDeleteRecordsOfAdvertisementProgress != null) {
        softDeleteRecordsOfAdvertisementProgress!.respond(rsp);
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
      if (removeListOfObjectFileProgress != null) {
        removeListOfObjectFileProgress!.respond(rsp);
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
                        Text('ID ：${advertisement.getId()}'),
                        Spacing.addVerticalSpace(20),
                        Text('${Translator.translate(Language.nameOfAdvertisement)} : ${advertisement.getName()}'),
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
                          onPressed: () async {
                            if (softDeleteRecordsOfAdvertisementProgress == null) {
                              var step = SoftDeleteRecordsOfAdvertisementStep.construct();
                              step.setAdvertisementIdList([advertisement.getId()]);
                              softDeleteRecordsOfAdvertisementProgress = SoftDeleteRecordsOfAdvertisementProgress.construct(
                                result: -1,
                                step: step,
                                message: Translator.translate(Language.attemptToSoftDeleteRecordOfAdvertisement),
                              );
                              softDeleteRecordsOfAdvertisementProgress!.show(context: context).then((value) {
                                if (value == Code.oK) {
                                  figureOutputObjectFileList();
                                  var step = RemoveListOfObjectFileStep.construct(listOfObjectFile: objectFileList);
                                  removeListOfObjectFileProgress = RemoveListOfObjectFileProgress.construct(
                                    result: -1,
                                    step: step,
                                    message: Translator.translate(Language.attemptToRemoveListOfObjectFile),
                                  );
                                  removeListOfObjectFileProgress!.show(context: context).then((value) {
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
                                  });
                                } else {
                                  showWarningDialog(context, Translator.translate(Language.operationTimeout));
                                }
                                softDeleteRecordsOfAdvertisementProgress = null;
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
