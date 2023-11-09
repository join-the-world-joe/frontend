import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchUserListOfConditionReq {
  final String _name;
  final String _phoneNumber;

  FetchUserListOfConditionReq(this._name, this._phoneNumber);

  Map<String, dynamic> toJson() => {
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
  required String name,
  required String phoneNumber,
}) {
  PacketClient packet = PacketClient.create();
  FetchUserListOfConditionReq req = FetchUserListOfConditionReq(name, phoneNumber);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.fetchUserListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}