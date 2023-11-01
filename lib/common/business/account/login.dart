import 'dart:typed_data';
import '../../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../route/major.dart';
import '../../route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class LoginReq {
  late String token;
  late String countryCode;
  late String phoneNumber;
  late String verificationCode;

  LoginReq(
      this.verificationCode, this.countryCode, this.phoneNumber, this.token);

  Map<String, dynamic> toJson() => {
        'verification_code': verificationCode,
        'country_code': countryCode,
        'phone_number': phoneNumber,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
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
    return Convert.Bytes2String(Convert.toBytes(this));
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

void login(
    {required String verificationCode,
    required String countryCode,
    required String phoneNumber,
    required String token}) {
  PacketClient packet = PacketClient.create();
  LoginReq req = LoginReq(verificationCode, countryCode, phoneNumber, token);
  packet.getHeader().setMajor(Major.account);
  packet.getHeader().setMinor(Minor.account.loginReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}

