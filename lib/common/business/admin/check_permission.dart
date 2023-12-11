import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import '../../protocol/admin/check_permission.dart';

void checkPermission({
  required String major,
  required String minor,
}) {
  Runtime.request(
    major: Major.admin,
    minor: Minor.admin.checkPermissionReq,
    body: CheckPermissionReq.construct(
      major: int.parse(major),
      minor: int.parse(minor),
    ),
  );

  // PacketClient packet = PacketClient.create();
  // CheckPermissionReq req = CheckPermissionReq.construct(
  //   major: int.parse(major),
  //   minor: int.parse(minor),
  // );
  //
  // packet.getHeader().setMajor(Major.admin);
  // packet.getHeader().setMinor(Minor.admin.checkPermissionReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
