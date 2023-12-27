import 'package:flutter_framework/app/config.dart';
import 'package:flutter_framework/common/business/admin/soft_delete_records_of_advertisement.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_records_of_advertisement.dart';
import 'package:flutter_framework/common/protocol/oss/remove_list_of_object_file.dart';

/*
three possible stage; requested, timeout, responded()
 */
class SoftDeleteRecordsOfAdvertisementProgress {
  String from = 'SoftDeleteRecordsOfAdvertisementProgress';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  List<int> _advertisementIdList = [];
  SoftDeleteRecordsOfAdvertisementRsp? _rsp;

  SoftDeleteRecordsOfAdvertisementProgress.construct() {
    _requested = false;
    _responded = false;
  }

  void setAdvertisementIdList(List<int> advertisementIdList) {
    _advertisementIdList = advertisementIdList;
  }

  void respond(SoftDeleteRecordsOfAdvertisementRsp? rsp) {
    _rsp = rsp;
    _responded = true;
  }

  void skip() {
    print('skip SoftDeleteRecordsOfAdvertisementProgress');
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
      _requestTime = DateTime.now();
      softDeleteRecordsOfAdvertisement(
        from: from,
        caller: caller,
        advertisementIdList: _advertisementIdList,
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
