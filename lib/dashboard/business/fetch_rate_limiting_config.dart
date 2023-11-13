import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class FetchRateLimitingConfigReq {
  Map<String, dynamic> toJson() => {};
}

class FetchRateLimitingConfigRsp {
  late int code;
  late dynamic body;

  FetchRateLimitingConfigRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    body = json['body'] ?? '';
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
