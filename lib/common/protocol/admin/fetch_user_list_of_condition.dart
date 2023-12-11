import 'dart:convert';

class FetchUserListOfConditionReq {
  int _behavior = -1;
  String _name = '';
  String _phoneNumber = '';
  int _userId = -1;

  FetchUserListOfConditionReq.construct({
    required int behavior,
    required String name,
    required String phoneNumber,
    required int userId,
  }) {
    _behavior = behavior;
    _name = name;
    _phoneNumber = phoneNumber;
    _userId = userId;
  }

  Map<String, dynamic> toJson() {
    return {
      'behavior': _behavior,
      'user_id': _userId,
      'name': utf8.encode(_name),
      'phone_number': _phoneNumber,
    };
  }
}

class FetchUserListOfConditionRsp {
  int _code = -1;
  dynamic _body;

  int getCode() {
    return _code;
  }

  dynamic getBody() {
    return _body;
  }

  FetchUserListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      _body = json['body'];
    }
  }
}
