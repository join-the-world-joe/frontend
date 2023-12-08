import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchUserListOfConditionReq {
  int _behavior = -1;
  String _name = '';
  String _phoneNumber = '';
  int _userId = -1;

  FetchUserListOfConditionReq.construct({
    required int behavior,
    required String name,
    required String phoneNumber,
    required int userId,
  }) {
    _behavior = behavior;
    _name = name;
    _phoneNumber = phoneNumber;
    _userId = userId;
  }

  Map<String, dynamic> toJson() {
    return {
      'behavior': _behavior,
      'user_id': _userId,
      'name': utf8.encode(_name),
      'phone_number': _phoneNumber,
    };
  }
}

class FetchUserListOfConditionRsp {
  int _code = -1;
  dynamic _body;

  int getCode() {
    return _code;
  }

  dynamic getBody() {
    return _body;
  }

  FetchUserListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      _body = json['body'];
    }
  }
}

void fetchUserListOfCondition({
  required int behavior,
  required String name,
  required String phoneNumber,
  required int userId,
}) {
  PacketClient packet = PacketClient.create();
  FetchUserListOfConditionReq req = FetchUserListOfConditionReq.construct(
    behavior: behavior,
    userId: userId,
    name: name,
    phoneNumber: phoneNumber,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchUserListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
