import 'dart:html';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class SignInReq {
  int behavior;
  String account;
  String email;
  String phoneNumber;
  String countryCode;
  Uint8List password;
  String token;
  int verificationCode;
  int userId;

  SignInReq({
    required this.email,
    required this.token,
    required this.account,
    required this.behavior,
    required this.password,
    required this.phoneNumber,
    required this.countryCode,
    required this.verificationCode,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'token': token,
        'account': account,
        'behavior': behavior,
        'password': password,
        'phone_number': phoneNumber,
        'country_code': countryCode,
        'verification_code': verificationCode,
        'user_id': userId,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class SignInRsp {
  late int code;
  late int userId;
  late String secret;
  late String token;

  int getCode() {
    return code;
  }

  String getToken() {
    return token;
  }

  String getSecret() {
    return secret;
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
      };

  SignInRsp.fromJson(Map<String, dynamic> json)
      : code = json['code'] ?? -1,
        userId = json['user_id'] ?? -1,
        secret = json['secret'] ?? -1,
        token = json['token'] ?? -1;
}

void signIn({
  required String email,
  required String token,
  required String account,
  required int behavior,
  required Uint8List password,
  required String phoneNumber,
  required String countryCode,
  required int verificationCode,
  required int userId,
}) {
  PacketClient packet = PacketClient.create();
  SignInReq req = SignInReq(
    email: email,
    token: token,
    account: account,
    behavior: behavior,
    password: password,
    phoneNumber: phoneNumber,
    countryCode: countryCode,
    verificationCode: verificationCode,
    userId: userId,
  );
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.signInReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
