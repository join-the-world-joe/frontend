import 'dart:typed_data';
import '../../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../route/major.dart';
import '../../route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchMenuListOfRoleListReq {
  final List<String> _conditionOfRoleList;

  FetchMenuListOfRoleListReq(this._conditionOfRoleList);

  Map<String, dynamic> toJson() => {
        'condition_of_role_list': _conditionOfRoleList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchMenuListOfRoleListRsp {
  late int code;
  late dynamic body;

  FetchMenuListOfRoleListRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchMenuListOfRoleList({
  required List<String> conditionOfRoleList,
}) {
  PacketClient packet = PacketClient.create();
  FetchMenuListOfRoleListReq req = FetchMenuListOfRoleListReq(conditionOfRoleList);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.fetchMenuListOfRoleListReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
