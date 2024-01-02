import 'dart:typed_data';
import '../../../../utils/convert.dart';

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