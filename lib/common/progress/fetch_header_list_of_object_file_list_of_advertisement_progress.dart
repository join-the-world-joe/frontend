import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/common/business/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/business/oss/fetch_header_list_of_object_file_list_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/insert_record_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/oss/fetch_header_list_of_object_file_list_of_advertisement.dart';
import 'package:flutter_framework/dashboard/model/advertisement.dart';

/*
three possible stage; requested, timeout, responded()
 */
class FetchHeaderListOfObjectFileListOfAdvertisementProgress {
  String from = 'FetchHeaderListOfObjectFileListOfAdvertisementProgress';
  int _result = -1;
  int _advertisementId = -1;
  List<String> _nameListOfFile = [];
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  bool _finished = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  FetchHeaderListOfObjectFileListOfAdvertisementRsp? _rsp;

  FetchHeaderListOfObjectFileListOfAdvertisementProgress.construct({
    required int result,
    required int advertisementId,
    required List<String> nameListOfFile,
  }) {
    _requested = false;
    _responded = false;
    _finished = false;
    _result = result;
    _advertisementId = advertisementId;
    _nameListOfFile = nameListOfFile;
  }

  void setAdvertisementId(int advertisementId) {
    _advertisementId = advertisementId;
  }

  int result() {
    return _result;
  }

  void skip() {
    print('skip FetchHeaderListOfObjectFileListOfAdvertisementProgress');
    _rsp = FetchHeaderListOfObjectFileListOfAdvertisementRsp.fromJson({"code": Code.oK});
    _result = 0;
    _requested = true;
    _responded = true;
    _finished = true;
  }

  void setNameListOfFile(List<String> nameListOfFile) {
    _nameListOfFile = nameListOfFile;
  }

  void respond(FetchHeaderListOfObjectFileListOfAdvertisementRsp? rsp) {
    _rsp = rsp;
    _responded = true;
  }

  bool finished() {
    return _finished;
  }

  int progress() {
    var caller = 'progress';
    if (!_requested) {
      fetchHeaderListOfObjectFileListOfAdvertisement(
        from: from,
        caller: caller,
        advertisementId: _advertisementId,
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
