import 'package:flutter_framework/dashboard/model/role_list.dart';

class FetchMenuListOfConditionReq {
  int _behavior = -1;
  int _userId = -1;
  RoleList _roleList = RoleList([]);

  FetchMenuListOfConditionReq.construct({
    required int behavior,
    required int userId,
    required RoleList roleList,
  }) {
    _behavior = behavior;
    _userId = userId;
    _roleList = roleList;
  }

  Map<String, dynamic> toJson() {
    return {
      'behavior': _behavior,
      'role_list': _roleList.getNameList(),
      'user_id': _userId,
    };
  }
}

class FetchMenuListOfConditionRsp {
  int _code = -1;
  dynamic _body;

  int getCode() {
    return _code;
  }

  dynamic getBody() {
    return _body;
  }

  FetchMenuListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      _body = json['body'];
    }
  }
}
