import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class FetchRoleListOfConditionReq {
  final int _userId;
  final int _behavior;
  final List<String> _roleNameList;

  FetchRoleListOfConditionReq(this._behavior, this._userId, this._roleNameList);

  Map<String, dynamic> toJson() => {
        'user_id': _userId,
        'behavior': _behavior,
        'role_list': _roleNameList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchRoleListOfConditionRsp {
  late int code;
  late dynamic body;

  FetchRoleListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchRoleListOfCondition({
  required int userId,
  required int behavior,
  required List<String> roleNameList,
}) {
  PacketClient packet = PacketClient.create();
  FetchRoleListOfConditionReq req = FetchRoleListOfConditionReq(behavior, userId, roleNameList);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.fetchRoleListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
