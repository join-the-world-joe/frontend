import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/oss/protocol/remove_list_of_object_file.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';
import 'package:flutter_framework/common/service/oss/business/remove_list_of_object_file.dart';

class RemoveListOfObjectFileProgress {
  String from = 'RemoveListOfObjectFileProgress';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  List<String> _objectFileToBeRemoved = [];
  RemoveListOfObjectFileRsp? _rsp;

  RemoveListOfObjectFileProgress.construct() {
    _requested = false;
    _responded = false;
  }

  setObjectFileToBeRemoved(List<String> objectFileToBeRemoved) {
    _objectFileToBeRemoved = objectFileToBeRemoved;
  }

  void respond(RemoveListOfObjectFileRsp? rsp) {
    _rsp = rsp;
    _responded = true;
  }

  void skip() {
    print('skip RemoveListOfObjectFileProgress');
    _rsp = RemoveListOfObjectFileRsp.fromJson({"code":Code.oK});
    _requested = true;
    _responded = true;
  }

  bool timeout() {
    if (!_responded && DateTime.now().isAfter(_requestTime.add(_defaultTimeout))) {
      return true;
    }
    return false;
  }

  int progress() {
    var caller = 'progress';
    if (!_requested) {
      _responded = false;
      _requestTime = DateTime.now();
      removeListOfObjectFile(
        from: from,
        caller: caller,
        listOfObjectFile: _objectFileToBeRemoved,
      );
      _requested = true;
    }
    if (_requested) {
      if (timeout()) {
        return Code.internalError;
      }
      if (_responded) {
        if (_rsp != null) {
          if (_rsp!.getCode() == Code.oK) {
            return Code.oK;
          }
        }
        return Code.internalError;
      }
    }
    return 1;
  }
}
