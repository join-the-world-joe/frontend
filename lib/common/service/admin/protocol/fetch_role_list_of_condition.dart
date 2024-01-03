import 'dart:convert';
import 'dart:typed_data';
import '../../../../utils/convert.dart';

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
}

class FetchRoleListOfConditionRsp {
   int _code = -1;
   dynamic _body;

   int getCode() {
     return _code;
   }

   dynamic getBody() {
     return _body;
   }

  FetchRoleListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    _code = json['code'] ?? -1;
    _body = json['body'] ?? '';
  }
}

