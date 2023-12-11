import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/admin/fetch_user_list_of_condition.dart';

void fetchUserListOfCondition({
  required int behavior,
  required String name,
  required String phoneNumber,
  required int userId,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.fetchUserListOfConditionReq,
    body: FetchUserListOfConditionReq.construct(
      behavior: behavior,
      userId: userId,
      name: name,
      phoneNumber: phoneNumber,
    ),
  );

  //
  // PacketClient packet = PacketClient.create();
  // FetchUserListOfConditionReq req = FetchUserListOfConditionReq.construct(
  //   behavior: behavior,
  //   userId: userId,
  //   name: name,
  //   phoneNumber: phoneNumber,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.fetchUserListOfConditionReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
