import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../../common/route/major.dart';
import '../../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchVersionOfADOfDealsReq {
  Map<String, dynamic> toJson() {
    return {};
  }
}

class FetchVersionOfADOfDealsRsp {
  int _code = Code.internalError;
  int _versionOfADOfDeals = -1;

  int getCode() {
    return _code;
  }

  int getVersion() {
    return _versionOfADOfDeals;
  }

  FetchVersionOfADOfDealsRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('version_of_ad_of_deals')) {
        _versionOfADOfDeals = body['version_of_ad_of_deals'];
      }
    }
  }
}

void fetchVersionOfADOfDeals() {
  PacketClient packet = PacketClient.create();
  FetchVersionOfADOfDealsReq req = FetchVersionOfADOfDealsReq();
  packet.getHeader().setMajor(Major.advertisement);
  packet.getHeader().setMinor(Minor.advertisement.fetchVersionOfADOfDealsReq_);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
