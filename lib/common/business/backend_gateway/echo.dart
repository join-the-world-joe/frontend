import 'dart:typed_data';
import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';
import 'package:flutter_framework/common/protocol/backend_gateway/echo.dart';

void echo({
  required String message,
}) {
  Runtime.request(
    body: PingReq.construct(
      message: message,
    ),
    major: Major.backendGateway,
    minor: Minor.backendGateway.pingReq,
  );
  //
  // PacketClient packet = PacketClient.create();
  // PingReq req = PingReq.construct(message: message);
  // packet.getHeader().setMajor(Major.backendGateway);
  // packet.getHeader().setMinor(Minor.backendGateway.pingReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
