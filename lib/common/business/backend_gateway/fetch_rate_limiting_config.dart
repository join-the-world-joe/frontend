import 'dart:convert';

import 'package:flutter_framework/common/route/major.dart';
import 'package:flutter_framework/common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/protocol/backend_gateway/fetch_rate_limiting_config.dart';

void fetchRateLimitingConfig() {
  Runtime.request(
    major: Major.backendGateway,
    minor: Minor.backendGateway.fetchRateLimitingConfigReq,
    body: FetchRateLimitingConfigReq(),
  );

  // PacketClient packet = PacketClient.create();
  // FetchRateLimitingConfigReq req = FetchRateLimitingConfigReq();
  // packet.getHeader().setMajor(Major.backendGateway);
  // packet.getHeader().setMinor(Minor.backendGateway.fetchRateLimitingConfigReq);
  // packet.setBody(req.toJson());
  // Runtime.wsClient.sendPacket(packet);
}
