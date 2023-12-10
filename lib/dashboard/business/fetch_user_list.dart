import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchUserListReq {
  String _role = '';
  String _name = '';
  String _phoneNumber = '';

  FetchUserListReq.construct({
    required String role,
    required String name,
    required phoneNumber,
  }) {
    _role = role;
    _name = name;
    _phoneNumber = phoneNumber;
  }

  Map<String, dynamic> toJson() {
    return {
      'role': _role,
      'name': _name,
      'phone_number': _phoneNumber,
    };
  }
}

class FetchUserListRsp {
  int _code = -1;
  List<String> _roleList = [];

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
    return Convert.bytes2String(Convert.toBytes(this));
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
  FetchUserListReq req = FetchUserListReq.construct(
    role: role,
    name: name,
    phoneNumber: phoneNumber,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.signInReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
