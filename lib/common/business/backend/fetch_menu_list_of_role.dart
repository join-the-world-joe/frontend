import 'dart:typed_data';
import '../../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../route/major.dart';
import '../../route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchMenuListOfRoleReq {
  String role = '';
  late String query;

  FetchMenuListOfRoleReq(this.query);

  Map<String, dynamic> toJson() => {
        'role': role,
        'query': query,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchMenuListOfRoleRsp {
  late int code;
  late dynamic body;

  FetchMenuListOfRoleRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchMenuListOfRole({
  required String query,
}) {
  PacketClient packet = PacketClient.create();
  FetchMenuListOfRoleReq req = FetchMenuListOfRoleReq(query);
  packet.getHeader().setMajor(Major.backend);
  packet.getHeader().setMinor(Minor.backend.fetchMenuListOfRoleReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
