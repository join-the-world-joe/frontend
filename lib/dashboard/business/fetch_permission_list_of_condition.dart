import 'dart:typed_data';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchPermissionListOfConditionReq {
  final RoleList _roleList;

  FetchPermissionListOfConditionReq(this._roleList);

  Map<String, dynamic> toJson() => {
        'role_list': _roleList.getNameList(),
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchPermissionListOfConditionRsp {
  late int code;
  late dynamic body;

  FetchPermissionListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchPermissionListOfCondition({
  required RoleList roleList,
}) {
  PacketClient packet = PacketClient.create();
  FetchPermissionListOfConditionReq req =
      FetchPermissionListOfConditionReq(roleList);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.fetchPermissionListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
