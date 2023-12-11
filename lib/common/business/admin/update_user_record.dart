import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/admin/update_user_record.dart';

void updateUserRecord({
  required String name,
  required int userId,
  required String phoneNumber,
  required String countryCode,
  required int status,
  required Uint8List password,
  required List<String> roleList,
}) {

  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.updateUserRecordReq,
    body:  UpdateUserRecordReq.construct(
      userId: userId,
      name: name,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      status: status,
      password: password,
      roleList: roleList,
    ),
  );


  // PacketClient packet = PacketClient.create();
  // UpdateUserRecordReq req = UpdateUserRecordReq.construct(
  //   userId: userId,
  //   name: name,
  //   phoneNumber: phoneNumber,
  //   countryCode: countryCode,
  //   status: status,
  //   password: password,
  //   roleList: roleList,
  // );
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.updateUserRecordReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
