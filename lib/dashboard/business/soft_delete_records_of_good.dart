import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';

class SoftDeleteRecordsOfGoodReq {
  List<int> _productIdList = [];

  SoftDeleteRecordsOfGoodReq.construct({required List<int> productIdList}) {
    _productIdList = productIdList;
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id_list': _productIdList,
    };
  }
}

class SoftDeleteRecordsOfGoodRsp {
  int code = -1;

  SoftDeleteRecordsOfGoodRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      code = json['code'];
    }
  }
}

void softDeleteRecordsOfGood({
  required List<int> productIdList,
}) {
  PacketClient packet = PacketClient.create();
  SoftDeleteRecordsOfGoodReq req = SoftDeleteRecordsOfGoodReq.construct(
    productIdList: productIdList,
  );
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.softDeleteRecordsOfGoodReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
