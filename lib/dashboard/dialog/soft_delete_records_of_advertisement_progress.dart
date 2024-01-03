import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/progress/soft_delete_record_of_advertisement_progress.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_advertisement.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/utils/spacing.dart';
import 'package:flutter_framework/common/translator/language.dart';
import 'package:flutter_framework/common/translator/translator.dart';
import '../config/config.dart';

class SoftDeleteRecordsOfAdvertisementProgressDialog {
  SoftDeleteRecordsOfAdvertisementProgress? step;
  double width = 220;
  double height = 150;
  int _result = -1;
  List<int> _advertisementIdList = [];

  void setAdvertisementIdList(List<int> advertisementIdList) {
    _advertisementIdList = advertisementIdList;
  }

  void respond(SoftDeleteRecordsOfAdvertisementRsp rsp) {
    if (step != null) {
      step!.respond(rsp);
    }
  }

  SoftDeleteRecordsOfAdvertisementProgressDialog.construct({
    required int result,
  }) {
    _result = result;
  }

  Future<int> show({
    required BuildContext context,
  }) async {
    bool closed = false;
    int curStage = 0;
    String information = '';

    bool hasFigureOutStepArgument = false;

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

    void progress() {
      if (!hasFigureOutStepArgument) {
        step!.setAdvertisementIdList(_advertisementIdList);
        hasFigureOutStepArgument = true;
      }

      var ret = step!.progress();
      if (ret < 0) {
        Navigator.pop(context);
        return;
      }
      if (ret == Code.oK) {
        _result = Code.oK;
        Navigator.pop(context);
        return;
      }

      return;
    }

    void setup() {
      Runtime.setPeriod(Config.periodOfScreenInitialisation);
      Runtime.setPeriodic(progress);
      step = SoftDeleteRecordsOfAdvertisementProgress.construct();
    }

    setup();

    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translator.translate(Language.removing)),
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
        Runtime.setPeriod(Config.periodOfScreenNormal);
        Runtime.setPeriodic(null);
        return _result;
      },
    );
  }
}
