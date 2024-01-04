import 'package:flutter/material.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/oss/progress/fetch_header_list_of_object_file_list/fetch_header_list_of_object_file_list_step.dart';
import 'package:flutter_framework/common/service/oss/protocol/fetch_header_list_of_object_file_list.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class FetchHeaderListOfObjectFileListProgress {
  late String _message;
  int _result = Code.internalError;
  late FetchHeaderListOfObjectFileListStep _step;
  bool _skip = false;

  void respond(FetchHeaderListOfObjectFileListRsp rsp) {
    _step.respond(rsp);
  }

  void skip() {
    _skip = true;
  }

  FetchHeaderListOfObjectFileListProgress.construct({
    required int result,
    required FetchHeaderListOfObjectFileListStep step,
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
      print('progress');
      if (_skip) {
        _result = Code.oK;
        Navigator.pop(context);
      }
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
