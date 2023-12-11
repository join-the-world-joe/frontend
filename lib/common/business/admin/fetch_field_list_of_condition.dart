import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/dashboard/model/role_list.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_field_list_of_condition.dart';

void fetchFieldListOfCondition({
  required int behavior,
  required String table,
  required String role,
  required String field,
}) {

  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.fetchFieldListOfConditionReq,
    body: FetchFieldListOfConditionReq.construct(
      behavior: behavior,
      table: table,
      field: field,
      role: role,
    ),
  );

  //
  // PacketClient packet = PacketClient.create();
  // FetchFieldListOfConditionReq req = FetchFieldListOfConditionReq.construct(
  //   behavior: behavior,
  //   table: table,
  //   field: field,
  //   role: role,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.fetchFieldListOfConditionReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}