import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/common/business/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/oss/remove_list_of_object_file.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';
import 'package:flutter_framework/common/business/oss/remove_list_of_object_file.dart';

/*
three possible stage; requested, timeout, responded()
 */
class RemoveListOfObjectFileProgress {
  String from = 'InsertRecordOfAdvertisementProgress';
  int _result = -1;
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  bool _finished = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  List<String> _objectFileToBeRemoved = [];
  RemoveListOfObjectFileRsp? _rsp;

  RemoveListOfObjectFileProgress.construct({
    required int result,
    required List<String> objectFileToBeRemoved,
  }) {
    _requested = false;
    _responded = false;
    _finished = false;
    _result = result;
    _objectFileToBeRemoved = objectFileToBeRemoved;
  }

  int result() {
    return _result;
  }

  void respond(RemoveListOfObjectFileRsp? rsp) {
    _rsp = rsp;
    _responded = true;
  }

  void skip() {
    print('skip RemoveListOfObjectFileProgress');
    _result = 0;
    _requested = true;
    _finished = true;
    _responded = true;
  }

  void setObjectFileToBeRemoved(List<String> objectFileToBeRemoved) {
    _objectFileToBeRemoved = objectFileToBeRemoved;
  }

  bool finished() {
    return _finished;
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
      if (!_responded && DateTime.now().isAfter(_requestTime.add(_defaultTimeout))) {
        _finished = true;
        return _result;
      }
      if (_responded) {
        if (_rsp != null) {
          if (_rsp!.getCode() == Code.oK) {
            _result = _rsp!.getCode();
            _finished = true;
            return Code.oK;
          }
        }
        _finished = true;
        return _result;
      }
    }
    return _result * -1;
  }
}
