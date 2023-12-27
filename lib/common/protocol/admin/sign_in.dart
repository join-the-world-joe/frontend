import 'dart:typed_data';
import '../../../utils/convert.dart';

class SignInReq {
  int _behavior = -1;
  String _account = '';
  String _email = '';
  String _phoneNumber = '';
  String _countryCode = '';
  Uint8List _password = Uint8List.fromList([]);
  String _memberId = '';
  int _verificationCode = -1;
  int _userId = -1;

  SignInReq.construct({
    required String email,
    required String memberId,
    required String account,
    required int behavior,
    required Uint8List password,
    required String phoneNumber,
    required String countryCode,
    required int verificationCode,
    required int userId,
  }) {
    _email = email;
    _userId = userId;
    _memberId = memberId;
    _account = account;
    _behavior = behavior;
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;
    _password = password;
    _verificationCode = verificationCode;
  }

  Map<String, dynamic> toJson() {
    return {
      'email': _email,
      'member_id': _memberId,
      'account': _account,
      'behavior': _behavior,
      'password': _password,
      'phone_number': _phoneNumber,
      'country_code': _countryCode,
      'verification_code': _verificationCode,
      'user_id': _userId,
    };
  }
}

class SignInRsp {
  int _code = -1;
  int _userId = -1;
  String _secret = '';
  String _memberId = '';
  String _name = '';

  SignInRsp({
    required int code,
    required int userId,
    required String secret,
    required String memberId,
    required String name,
  }) {
    _code = code;
    _name = name;
    _secret = secret;
    _userId = userId;
    _memberId = memberId;
  }

  int getCode() {
    return _code;
  }

  String getName() {
    return _name;
  }

  String getMemberId() {
    return _memberId;
  }

  String getSecret() {
    return _secret;
  }

  int getUserId() {
    return _userId;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  SignInRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('code')) {
        _code = body['code'];
      }
      if (body.containsKey('user_id')) {
        _userId = body['user_id'];
      }
      if (body.containsKey('secret')) {
        _secret = body['secret'];
      }
      if (body.containsKey('name')) {
        _name = body['name'];
      }
      if (body.containsKey('member_id')) {
        _memberId = body['member_id'];
      }
    }
  }
}
