import 'dart:typed_data';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/business/sign_in.dart';
import 'package:flutter_framework/common/service/admin/business/soft_delete_records_of_product.dart';
import 'package:flutter_framework/common/service/admin/business/soft_delete_records_of_user.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/sign_in.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/soft_delete_records_of_user.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/utils/convert.dart';

class SoftDeleteRecordsOfUserStep {
  String from = 'SoftDeleteRecordsOfUserStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  SoftDeleteRecordsOfUserRsp? _rsp;
  List<int> _userIdList = [];

  SoftDeleteRecordsOfUserStep.construct({required List<int> userIdList}) {
    _rsp = null;
    _requested = false;
    _responded = false;
    _userIdList = userIdList;
  }

  int getCode() {
    if (_rsp != null) {
      return _rsp!.getCode();
    }
    return 1;
  }

  void respond(SoftDeleteRecordsOfUserRsp rsp) {
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
      softDeleteRecordsOfUser(
        from: from,
        caller: caller,
        userList: _userIdList,
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
