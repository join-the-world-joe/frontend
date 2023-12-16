import 'dart:typed_data';
import '../../../../utils/convert.dart';
import '../../route/major.dart';
import '../../route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class RegisterReq {
  late String countryCode;
  late String phoneNumber;
  late String verificationCode;

  RegisterReq(this.verificationCode, this.countryCode, this.phoneNumber);

  Map<String, dynamic> toJson() => {
    'verification_code': verificationCode,
    'country_code': countryCode,
    'phone_number': phoneNumber,
  };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class RegisterRsp {
  late int code;

  int getCode() {
    return code;
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
  };

  RegisterRsp.fromJson(Map<String, dynamic> json) : code = json['code'] ?? -1;
}