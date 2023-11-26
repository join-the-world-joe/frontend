import 'dart:typed_data';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchFieldListOfConditionReq {
  int _behavior;
  String _table;
  String _role;
  String _field;

  FetchFieldListOfConditionReq(this._behavior, this._table, this._field, this._role);

  Map<String, dynamic> toJson() => {
        'behavior': _behavior,
        'role': _role,
        'table': _table,
        'field': _field,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchFieldListOfConditionRsp {
  late int code;
  late dynamic body;

  FetchFieldListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
  }
}

void fetchFieldListOfCondition({
  required int behavior,
  required String table,
  required String role,
  required String field,
}) {
  PacketClient packet = PacketClient.create();
  FetchFieldListOfConditionReq req = FetchFieldListOfConditionReq(behavior, table, field, role);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchFieldListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
