import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class SoftDeleteRecordsOfAdvertisementReq {
  List<int> _advertisementIdList = [];

  SoftDeleteRecordsOfAdvertisementReq.construct({required List<int> advertisementIdList}) {
    _advertisementIdList = advertisementIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'advertisement_id_list': _advertisementIdList,
    };
  }
}

class SoftDeleteRecordsOfAdvertisementRsp {
  int code = -1;

  SoftDeleteRecordsOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
  }
}

void softDeleteRecordsOfAdvertisement({
  required List<int> advertisementIdList,
}) {
  PacketClient packet = PacketClient.create();
  SoftDeleteRecordsOfAdvertisementReq req = SoftDeleteRecordsOfAdvertisementReq.construct(
    advertisementIdList: advertisementIdList,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.softDeleteRecordsOfAdvertisementReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
