import 'dart:typed_data';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchMenuListOfConditionReq {
  int _behavior;
  int _userId;
  RoleList _roleList;

  FetchMenuListOfConditionReq(this._behavior, this._userId, this._roleList);

  Map<String, dynamic> toJson() => {
        'behavior': _behavior,
        'role_list': _roleList.getNameList(),
        'user_id': _userId,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchMenuListOfConditionRsp {
  late int code;
  late dynamic body;

  FetchMenuListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchMenuListOfCondition({
  required int behavior,
  required int userId,
  required RoleList roleList,
}) {
  PacketClient packet = PacketClient.create();
  FetchMenuListOfConditionReq req = FetchMenuListOfConditionReq(behavior, userId, roleList);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.fetchMenuListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
