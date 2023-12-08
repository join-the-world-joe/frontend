import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class SoftDeleteUserRecordReq {
  List<int> _userIdList = [];

  SoftDeleteUserRecordReq.construct({
    required List<int> userIdList,
  }) {
    _userIdList = userIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id_list': _userIdList,
    };
  }
}

class SoftDeleteUserRecordRsp {
  int _code = -1;

  int getCode() {
    return _code;
  }

  SoftDeleteUserRecordRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
  }
}

void softDeleteUserRecord({
  required List<int> userList,
}) {
  PacketClient packet = PacketClient.create();
  SoftDeleteUserRecordReq req = SoftDeleteUserRecordReq.construct(
    userIdList: userList,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.softDeleteUserRecordReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
