import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchUserListOfConditionReq {
  final int _behavior;
  final String _name;
  final String _phoneNumber;
  final int _userId;

  FetchUserListOfConditionReq(this._behavior, this._userId, this._name, this._phoneNumber);

  Map<String, dynamic> toJson() => {
        'behavior': _behavior,
        'user_id': _userId,
        'name': utf8.encode(_name),
        'phone_number': _phoneNumber,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchUserListOfConditionRsp {
  late int code;
  late dynamic body;

  FetchUserListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchUserListOfCondition({
  required int behavior,
  required String name,
  required String phoneNumber,
  required int userId,
}) {
  PacketClient packet = PacketClient.create();
  FetchUserListOfConditionReq req = FetchUserListOfConditionReq(behavior, userId, name, phoneNumber);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchUserListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
