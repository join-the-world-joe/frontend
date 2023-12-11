import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/soft_delete_user_record.dart';

void softDeleteUserRecord({
  required List<int> userList,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.softDeleteUserRecordReq,
    body:  SoftDeleteUserRecordReq.construct(
      userIdList: userList,
    ),
  );

  // PacketClient packet = PacketClient.create();
  // SoftDeleteUserRecordReq req = SoftDeleteUserRecordReq.construct(
  //   userIdList: userList,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.softDeleteUserRecordReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
