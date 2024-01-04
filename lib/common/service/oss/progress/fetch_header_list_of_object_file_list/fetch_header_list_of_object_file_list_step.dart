import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/oss/business/fetch_header_list_of_object_file_list.dart';
import 'package:flutter_framework/common/service/oss/protocol/fetch_header_list_of_object_file_list.dart';
import 'package:flutter_framework/dashboard/config/config.dart';

class FetchHeaderListOfObjectFileListStep {
  String from = 'FetchHeaderListOfObjectFileListStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  FetchHeaderListOfObjectFileListRsp? _rsp;
  List<String> _nameListOfFile = [];

  FetchHeaderListOfObjectFileListStep.construct() {
    _rsp = null;
    _requested = false;
    _responded = false;
  }

  void setNameListOfFile(List<String> nameListOfFile) {
    _nameListOfFile = nameListOfFile;
  }

  void respond(FetchHeaderListOfObjectFileListRsp rsp) {
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
      fetchHeaderListOfObjectFileList(
        from: from,
        caller: caller,
        nameListOfFile: _nameListOfFile,
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
    return Code.internalError * -1;
  }
}
