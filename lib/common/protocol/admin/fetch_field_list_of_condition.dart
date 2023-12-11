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
  int code = -1;
  dynamic body;

  FetchFieldListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
    if (json.containsKey('body')) {
      body = json['body'];
    }
  }
}
