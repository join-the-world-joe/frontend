import 'dart:typed_data';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchPermissionListOfConditionReq {
  final String _name; // the name of permission
  final int _major;
  final int _minor;
  final int _userId;
  final int _behavior;
  final RoleList _roleList;

  FetchPermissionListOfConditionReq(this._name, this._major, this._minor, this._userId, this._behavior, this._roleList);

  Map<String, dynamic> toJson() => {
        'name': _name,
        'major': _major,
        'minor': _minor,
        'user_id': _userId,
        'behavior': _behavior,
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
  required String name,
  required int major,
  required int minor,
  required int userId,
  required int behavior,
  required RoleList roleList,
}) {
  PacketClient packet = PacketClient.create();
  FetchPermissionListOfConditionReq req = FetchPermissionListOfConditionReq(name, major, minor, userId, behavior, roleList);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.fetchPermissionListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
