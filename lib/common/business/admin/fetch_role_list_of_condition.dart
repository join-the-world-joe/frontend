import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_role_list_of_condition.dart';

void fetchRoleListOfCondition({
  required int userId,
  required int behavior,
  required List<String> roleNameList,
}) {

  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.fetchRoleListOfConditionReq,
    body: FetchRoleListOfConditionReq.construct(
      behavior: behavior,
      userId: userId,
      roleNameList: roleNameList,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // FetchRoleListOfConditionReq req = FetchRoleListOfConditionReq.construct(
  //   behavior: behavior,
  //   userId: userId,
  //   roleNameList: roleNameList,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.fetchRoleListOfConditionReq);
  // packet.setBody(req.toJson());
  // print('req: ${req.toJson()}');
  // Runtime.wsClient.sendPacket(packet);
}
