import 'dart:convert';

import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/framework/rate_limiter.dart';

class FetchRateLimitingConfigReq {
  Map<String, dynamic> toJson() => {};
}

class FetchRateLimitingConfigRsp {
  late int code;
  Map<String, RateLimiter> rateLimiter = {};

  FetchRateLimitingConfigRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    rateLimiter = {};
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('rate_limit_list')) {
        Map<String, dynamic> any = body['rate_limit_list'];
        any.forEach(
          (key, value) {
            rateLimiter['${value['major']}-${value['minor']}'] = RateLimiter(value['major'], value['minor'], value['period']);
          },
        );
      }
    }
  }
}

void fetchRateLimitingConfig() {
  PacketClient packet = PacketClient.create();
  FetchRateLimitingConfigReq req = FetchRateLimitingConfigReq();
  packet.getHeader().setMajor(Major.gateway);
  packet.getHeader().setMinor(Minor.gateway.fetchRateLimitingConfigReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
