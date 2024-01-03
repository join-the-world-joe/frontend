import 'dart:typed_data';
import 'package:flutter_framework/dashboard/model/role_list.dart';

class FetchFieldListOfConditionReq {
  int _behavior = -1;
  String _table = '';
  String _role = '';
  String _field = '';

  FetchFieldListOfConditionReq.construct({
    required int behavior,
    required String table,
    required String role,
    required String field,
  }) {
    _behavior = behavior;
    _table = table;
    _role = role;
    _field = field;
  }

  Map<String, dynamic> toJson() {
    return {
      'behavior': _behavior,
      'role': _role,
      'table': _table,
      'field': _field,
    };
  }
}

class FetchFieldListOfConditionRsp {
  int _code = -1;
  dynamic _body;

  int getCode() {
    return _code;
  }

  dynamic getBody() {
    return _body;
  }

  FetchFieldListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      _body = json['body'];
    }
  }
}
