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
  String memberId;
  int verificationCode;
  int userId;

  SignInReq({
    required this.email,
    required this.memberId,
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
        'member_id': memberId,
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
  late int _code;
  late int _userId;
  late String _secret;
  late String _memberId;
  late String _name;

  SignInRsp(this._code, this._name, this._secret, this._userId, this._memberId);

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

  @override
  String toString() {
    return Convert.bytes2String(Convert.toBytes(this));
  }

  SignInRsp.fromJson(Map<String, dynamic> json) {
    print('json: ${json.toString()}');
    if (json.containsKey('body')) {
      var body = json['body'];
      _code = body['code'] ?? -1;
      _userId = body['user_id'] ?? -1;
      _secret = body['secret'] ?? "";
      _memberId = body['member_id'] ?? "";
      _name = body['name'] ?? "";
    }
  }
}

void signIn({
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
  PacketClient packet = PacketClient.create();
  SignInReq req = SignInReq(
    email: email,
    memberId: memberId,
    account: account,
    behavior: behavior,
    password: password,
    phoneNumber: phoneNumber,
    countryCode: countryCode,
    verificationCode: verificationCode,
    userId: userId,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.signInReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
