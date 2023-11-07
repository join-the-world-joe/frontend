import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class SignInReq {
  late String token;
  late String countryCode;
  late String phoneNumber;
  late String verificationCode;
  late Uint8List password;

  SignInReq(this.verificationCode, this.countryCode, this.phoneNumber,
      this.token, this.password);

  Map<String, dynamic> toJson() => {
        'verification_code': verificationCode,
        'country_code': countryCode,
        'phone_number': phoneNumber,
        'token': token,
        'password': password,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class SignInRsp {
  late int code;

  int getCode() {
    return code;
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
      };

  SignInRsp.fromJson(Map<String, dynamic> json)
      : code = json['code'] ?? -1;
}

void signIn(
    {required String verificationCode,
    required String countryCode,
    required String phoneNumber,
    required String token,
    required Uint8List password}) {
  PacketClient packet = PacketClient.create();
  SignInReq req =
      SignInReq(verificationCode, countryCode, phoneNumber, token, password);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.signInReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
