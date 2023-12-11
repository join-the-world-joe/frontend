import 'dart:convert';
import 'dart:typed_data';

class UpdateUserRecordReq {
  String _name = '';
  int _userId = -1;
  int _status = 0;
  Uint8List _password = Uint8List.fromList([]);
  String _countryCode = '';
  String _phoneNumber = '';
  List<String> _roleList = [];

  UpdateUserRecordReq.construct({
    required String name,
    required int userId,
    required int status,
    required Uint8List password,
    required String countryCode,
    required String phoneNumber,
    required List<String> roleList,
  }) {
    _name = name;
    _userId = userId;
    _status = status;
    _password = password;
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;
    _roleList = roleList;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': utf8.encode(_name),
      'user_id': _userId,
      'phone_number': _phoneNumber,
      'country_code': _countryCode,
      'status': _status,
      'password': _password,
      'role_list': _roleList,
    };
  }
}

class UpdateUserRecordRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  UpdateUserRecordRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
