import 'package:flutter_framework/dashboard/model/role_list.dart';

class FetchPermissionListOfConditionReq {
  String _name = ''; // the name of permission
  String _major = '';
  String _minor = '';
  int _userId = -1;
  int _behavior = -1;
  RoleList _roleList = RoleList([]);

  FetchPermissionListOfConditionReq.construct({
    required String name,
    required String major,
    required String minor,
    required int userId,
    required int behavior,
    required RoleList roleList,
  }) {
    _name = name;
    _major = major;
    _minor = minor;
    _userId = userId;
    _behavior = behavior;
    _roleList = roleList;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'major': _major,
      'minor': _minor,
      'user_id': _userId,
      'behavior': _behavior,
      'role_list': _roleList.getNameList(),
    };
  }
}

class FetchPermissionListOfConditionRsp {
  int _code = -1;
  dynamic _body;

  int getCode() {
    return _code;
  }

  dynamic getBody() {
    return _body;
  }

  FetchPermissionListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      _body = json['body'];
    }
  }
}
