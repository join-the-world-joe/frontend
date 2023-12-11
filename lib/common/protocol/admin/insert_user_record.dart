import 'dart:convert';
import 'dart:typed_data';

class InsertUserRecordReq {
  String _name = '';
  String _phoneNumber = '';
  String _countryCode = '';
  int _status = 0;
  Uint8List _password = Uint8List.fromList([]);
  List<String> _roleList = [];

  InsertUserRecordReq.construct({
    required String name,
    required String phoneNumber,
    required String countryCode,
    required int status,
    required Uint8List password,
    required List<String> roleList,
  }) {
    _name = name;
    _phoneNumber = phoneNumber;
    _countryCode = countryCode;
    _status = status;
    _password = password;
    _roleList = roleList;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': utf8.encode(_name),
      'phone_number': _phoneNumber,
      'country_code': _countryCode,
      'status': _status,
      'password': _password,
      'role_list': _roleList,
    };
  }
}

class InsertUserRecordRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  InsertUserRecordRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}
