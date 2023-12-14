import 'dart:typed_data';
import '../../../../utils/convert.dart';
import '../../route/major.dart';
import '../../route/minor.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';

// behavior begin

// behavior end

class Behavior {
  static const String login = 'Login';
  static const String signIn = 'SignIn';
  static const String register = 'Register';
}

class SendVerificationCodeReq {
  late String behavior;
  late String countryCode;
  late String phoneNumber;

  SendVerificationCodeReq(this.behavior, this.countryCode, this.phoneNumber);

  Map<String, dynamic> toJson() => {
        'behavior': behavior,
        'country_code': countryCode,
        'phone_number': phoneNumber,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class SendVerificationCodeRsp {
   int _code = -1;

  int getCode() {
    return _code;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  Map<String, dynamic> toJson() => {
        "code": _code,
      };

  SendVerificationCodeRsp.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('code')){
      _code = json['code'];
    }
  }

}

void sendVerificationCode(
    {required String behavior,
    required String countryCode,
    required String phoneNumber}) {
  PacketClient packet = PacketClient.create();
  SendVerificationCodeReq req =
      SendVerificationCodeReq(behavior, countryCode, phoneNumber);
  packet.getHeader().setMajor(Major.sms);
  packet.getHeader().setMinor(Minor.sms.sendVerificationCodeReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
