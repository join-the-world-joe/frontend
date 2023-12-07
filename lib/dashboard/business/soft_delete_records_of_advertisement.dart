import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class SoftDeleteRecordsOfAdvertisementReq {
  final List<int> _advertisementIdList;

  SoftDeleteRecordsOfAdvertisementReq(this._advertisementIdList);

  Map<String, dynamic> toJson() => {
        'advertisement_id_list': _advertisementIdList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class SoftDeleteRecordsOfAdvertisementRsp {
  int code = -1;

  SoftDeleteRecordsOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
  }
}

void softDeleteRecordsOfAdvertisement({
  required List<int> advertisementIdList,
}) {
  PacketClient packet = PacketClient.create();
  SoftDeleteRecordsOfAdvertisementReq req = SoftDeleteRecordsOfAdvertisementReq(advertisementIdList);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.softDeleteRecordsOfAdvertisementReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
