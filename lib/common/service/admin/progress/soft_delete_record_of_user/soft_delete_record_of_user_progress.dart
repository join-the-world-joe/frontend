import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/progress/soft_delete_record_of_user/soft_delete_record_of_user_step.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_user.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class SoftDeleteRecordsOfUserProgress {
  late String _message;
  int _result = Code.internalError;
  late SoftDeleteRecordsOfUserStep _step;

  void respond(SoftDeleteRecordsOfUserRsp rsp) {
    _step.respond(rsp);
  }

  SoftDeleteRecordsOfUserProgress.construct({
    required int result,
    required SoftDeleteRecordsOfUserStep step,
    required String message,
  }) {
    _step = step;
    _result = result;
    _message = message;
  }

  Future<int> show({
    required BuildContext context,
  }) async {
    void progress() {
      var ret = _step.progress();
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
    }

    setup();

    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(_message),
            ],
          ),
        );
      },
    ).then(
      (value) {
        Runtime.setPeriod(Config.periodOfScreenNormal);
        Runtime.setPeriodic(null);
        return _result;
      },
    );
  }
}
