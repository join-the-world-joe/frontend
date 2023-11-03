import 'dart:typed_data';
import '../../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../route/major.dart';
import '../../route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchUserListReq {
  final String _role;
  final String _name;
  final String _phoneNumber;

  FetchUserListReq(this._role, this._name, this._phoneNumber);

  Map<String, dynamic> toJson() => {
        'role': _role,
        'name': _name,
        'phone_number': _phoneNumber,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchUserListRsp {
  late int _code;
  late List<String> _roleList;

  int getCode() {
    return _code;
  }

  List<String> getRoleList() {
    return _roleList;
  }

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }

  @override
  String toString() {
    return Convert.Bytes2String(Convert.toBytes(this));
  }

  FetchUserListRsp.fromJson(Map<String, dynamic> json) {
    _code = json['code'] ?? -1;
    _roleList = json['role_list'] ?? [''];
  }
}

void fetchUserList({
  required String name,
  required String role,
  required String phoneNumber,
}) {
  PacketClient packet = PacketClient.create();
  FetchUserListReq req = FetchUserListReq(role, name, phoneNumber);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.signInReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
