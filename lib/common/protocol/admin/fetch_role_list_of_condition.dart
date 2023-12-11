import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';

class FetchRoleListOfConditionReq {
  int _userId = -1;
  int _behavior = -1;
  List<String> _roleNameList = [];

  FetchRoleListOfConditionReq.construct({
    required int userId,
    required int behavior,
    required List<String> roleNameList,
  }) {
    _userId = userId;
    _behavior = behavior;
    _roleNameList = roleNameList;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': _userId,
      'behavior': _behavior,
      'role_list': _roleNameList.map((e) => utf8.encode(e)).toList(),
    };
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchRoleListOfConditionRsp {
  late int code;
  late dynamic body;

  FetchRoleListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}
