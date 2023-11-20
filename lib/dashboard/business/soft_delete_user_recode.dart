import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class SoftDeleteUserRecordReq {
  final List<int> _userIdList;

  SoftDeleteUserRecordReq(this._userIdList);

  Map<String, dynamic> toJson() => {
        'user_id_list': _userIdList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class SoftDeleteUserRecordRsp {
  late int code;

  SoftDeleteUserRecordRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
  }
}

void softDeleteUserRecord({
  required List<int> userList,
}) {
  PacketClient packet = PacketClient.create();
  SoftDeleteUserRecordReq req = SoftDeleteUserRecordReq(userList);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.softDeleteUserRecordReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
