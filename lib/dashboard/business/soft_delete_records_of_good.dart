import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class SoftDeleteRecordsOfGoodReq {
  final List<int> _productIdList;

  SoftDeleteRecordsOfGoodReq(this._productIdList);

  Map<String, dynamic> toJson() => {
        'product_id_list': _productIdList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class SoftDeleteRecordsOfGoodRsp {
  int code = -1;

  SoftDeleteRecordsOfGoodRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
  }
}

void softDeleteRecordsOfGood({
  required List<int> productIdList,
}) {
  PacketClient packet = PacketClient.create();
  SoftDeleteRecordsOfGoodReq req = SoftDeleteRecordsOfGoodReq(productIdList);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.softDeleteRecordsOfGoodReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
