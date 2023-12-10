import 'dart:typed_data';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchFieldListOfConditionReq {
  int _behavior = -1;
  String _table = '';
  String _role = '';
  String _field = '';

  FetchFieldListOfConditionReq.construct({
    required int behavior,
    required String table,
    required String role,
    required String field,
  }) {
    _behavior = behavior;
    _table = table;
    _role = role;
    _field = field;
  }

  Map<String, dynamic> toJson() {
    return {
      'behavior': _behavior,
      'role': _role,
      'table': _table,
      'field': _field,
    };
  }
}

class FetchFieldListOfConditionRsp {
  int code = -1;
  dynamic body;

  FetchFieldListOfConditionRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
    if (json.containsKey('body')) {
      body = json['body'];
    }
  }
}

void fetchFieldListOfCondition({
  required int behavior,
  required String table,
  required String role,
  required String field,
}) {
  PacketClient packet = PacketClient.create();
  FetchFieldListOfConditionReq req = FetchFieldListOfConditionReq.construct(
    behavior: behavior,
    table: table,
    field: field,
    role: role,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchFieldListOfConditionReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
