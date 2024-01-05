import 'dart:typed_data';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/business/insert_record_of_user.dart';
import 'package:flutter_framework/common/service/admin/business/sign_in.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_record_of_product.dart';
import 'package:flutter_framework/common/service/admin/protocol/insert_user_record.dart';
import 'package:flutter_framework/common/service/admin/protocol/sign_in.dart';
import 'package:flutter_framework/dashboard/cache/cache.dart';
import 'package:flutter_framework/dashboard/config/config.dart';
import 'package:flutter_framework/utils/convert.dart';

class InsertRecordOfUserStep {
  String from = 'InsertRecordOfUserStep';
  DateTime _requestTime = DateTime.now();
  bool _requested = false;
  bool _responded = false;
  final Duration _defaultTimeout = Config.httpDefaultTimeout;
  InsertRecordOfUserRsp? _rsp;
  String _name = '';
  String _phoneNumber = '';
  String _countryCode = '';
  int _status = 0;
  Uint8List _password = Uint8List.fromList([]);
  List<String> _roleList = [];

  InsertRecordOfUserStep.construct({
    required String name,
    required String phoneNumber,
    required String countryCode,
    required int status,
    required Uint8List password,
    required List<String> roleList,
  }) {
    _rsp = null;
    _requested = false;
    _responded = false;
    _name = name;
    _phoneNumber = phoneNumber;
    _countryCode = countryCode;
    _status = status;
    _password = password;
    _roleList = roleList;
  }

  int getCode() {
    if (_rsp != null) {
      return _rsp!.getCode();
    }
    return 1;
  }

  void respond(InsertRecordOfUserRsp rsp) {
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
      insertRecordOfUser(
        from: from,
        caller: caller,
        name: _name,
        phoneNumber: _phoneNumber,
        countryCode: _countryCode,
        status: _status,
        password: _password,
        roleList: _roleList,
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
