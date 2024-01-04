import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/oss/business/fetch_header_list_of_object_file_list.dart';
import 'package:flutter_framework/common/service/oss/protocol/fetch_header_list_of_object_file_list.dart';

/*
three possible stage; requested, timeout, responded()
 */
class FetchHeaderListOfObjectFileListProgress {
  String from = 'FetchHeaderListOfObjectFileListProgress';
  int _result = -1;
  String _ossFolder = '';
  List<String> _nameListOfFile = [];
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  bool _finished = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  FetchHeaderListOfObjectFileListRsp? _rsp;

  FetchHeaderListOfObjectFileListProgress.construct({
    required int result,
    required String ossFolder,
    required List<String> nameListOfFile,
  }) {
    _requested = false;
    _responded = false;
    _finished = false;
    _result = result;
    _ossFolder = ossFolder;
    _nameListOfFile = nameListOfFile;
  }

  void setOSSFolder(String ossFolder) {
    _ossFolder = ossFolder;
  }

  int result() {
    return _result;
  }

  void skip() {
    print('skip FetchHeaderListOfObjectFileListProgress');
    _rsp = FetchHeaderListOfObjectFileListRsp.fromJson({"code": Code.oK});
    _result = 0;
    _requested = true;
    _responded = true;
    _finished = true;
  }

  void setNameListOfFile(List<String> nameListOfFile) {
    _nameListOfFile = nameListOfFile;
  }

  void respond(FetchHeaderListOfObjectFileListRsp? rsp) {
    _rsp = rsp;
    _responded = true;
  }

  bool finished() {
    return _finished;
  }

  int progress() {
    var caller = 'progress';
    if (!_requested) {
      fetchHeaderListOfObjectFileList(
        from: from,
        caller: caller,
        nameListOfFile: _nameListOfFile,
      );
      _responded = false;
      _requestTime = DateTime.now();
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
