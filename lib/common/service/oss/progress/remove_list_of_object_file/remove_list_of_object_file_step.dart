import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/oss/business/remove_list_of_object_file.dart';
import 'package:flutter_framework/common/service/oss/protocol/remove_list_of_object_file.dart';
import 'package:flutter_framework/dashboard/config/config.dart';

class RemoveListOfObjectFileStep {
  String from = 'RemoveListOfObjectFileStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  RemoveListOfObjectFileRsp? _rsp;
  List<String> _listOfObjectFile = [];

  RemoveListOfObjectFileStep.construct({required List<String> listOfObjectFile}) {
    _rsp = null;
    _requested = false;
    _responded = false;
    _listOfObjectFile = listOfObjectFile;
  }

  void respond(RemoveListOfObjectFileRsp rsp) {
    _rsp = rsp;
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
      _requestTime = DateTime.now();
      removeListOfObjectFile(
        from: from,
        caller: caller,
        listOfObjectFile: _listOfObjectFile,
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
            // print('ok');
            return Code.oK;
          }
        }
        return Code.internalError;
      }
    }
    return Code.internalError * -1;
  }
}
