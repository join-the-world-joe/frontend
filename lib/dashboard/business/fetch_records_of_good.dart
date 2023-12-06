import 'dart:convert';

import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/framework/rate_limiter.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../common/route/major.dart';
import '../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import '../model/product.dart';

class FetchRecordsOfGoodReq {
  final List<int> _productIdList;

  FetchRecordsOfGoodReq(this._productIdList);

  Map<String, dynamic> toJson() => {
        'product_id_list': _productIdList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchRecordsOfGoodRsp {
  int code = -1;
  Map<int, Product> productMap = {};

  int getCode() {
    return code;
  }

  Map<int, Product> getProductMap() {
    return productMap;
  }

  FetchRecordsOfGoodRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    if (json.containsKey('body')) {
      var body = json['body'];
      if (body.containsKey('records_of_good')) {
        final Map some = Map.from(body['records_of_good']);
        some.forEach((key, value) {
          productMap[value['id']] = Product(
            value['id'],
            value['name'],
            value['buying_price'],
            value['description'],
            value['status'],
            value['vendor'],
            value['created_at'],
            value['contact'],
            value['updated_at'],
          );
        });
      }
    }
  }
}

void fetchRecordsOfGood({
  required List<int> productList,
}) {
  PacketClient packet = PacketClient.create();
  FetchRecordsOfGoodReq req = FetchRecordsOfGoodReq(productList);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchRecordsOfGoodReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
