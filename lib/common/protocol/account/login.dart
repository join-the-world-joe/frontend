import 'dart:typed_data';
import '../../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../route/major.dart';
import '../../route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class LoginReq {
  late String _token;
  late String _countryCode;
  late String _phoneNumber;
  late String _verificationCode;

  LoginReq.construct({
    required String verificationCode,
    required String countryCode,
    required String token,
    required String phoneNumber,
  }) {
    _token = token;
    _countryCode = countryCode;
    _phoneNumber = phoneNumber;
    _verificationCode = verificationCode;
  }

  Map<String, dynamic> toJson() => {
        'verification_code': _verificationCode,
        'country_code': _countryCode,
        'phone_number': _phoneNumber,
        'token': _token,
      };
}

class LoginRsp {
  late int code;
  late String token;
  late int userId;

  int getCode() {
    return code;
  }

  String getToken() {
    return token;
  }

  int getUserId() {
    return userId;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'token': token,
        'user_id': userId,
      };

  LoginRsp.fromJson(Map<String, dynamic> json)
      : code = json['code'] ?? -1,
        token = json['token'] ?? '',
        userId = json['user_id'] ?? -1;
}
