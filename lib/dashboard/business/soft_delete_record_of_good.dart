import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class SoftDeleteRecordOfGoodReq {
  final List<int> _productIdList;

  SoftDeleteRecordOfGoodReq(this._productIdList);

  Map<String, dynamic> toJson() => {
        'product_id_list': _productIdList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class SoftDeleteRecordOfGoodRsp {
  int code = -1;

  SoftDeleteRecordOfGoodRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
  }
}

void softDeleteRecordOfGood({
  required List<int> productIdList,
}) {
  PacketClient packet = PacketClient.create();
  SoftDeleteRecordOfGoodReq req = SoftDeleteRecordOfGoodReq(productIdList);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.softDeleteRecordOfGoodReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
