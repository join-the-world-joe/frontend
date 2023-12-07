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
import '../model/advertisement.dart';

class FetchRecordsOfAdvertisementReq {
  final List<int> _advertisementIdList;

  FetchRecordsOfAdvertisementReq(this._advertisementIdList);

  Map<String, dynamic> toJson() => {
        'advertisement_id_list': _advertisementIdList,
      };

  Uint8List toBytes() {
    return Convert.toBytes(this);
  }
}

class FetchRecordsOfAdvertisementRsp {
  int code = -1;
  Map<int, Advertisement> advertisementMap = {};

  int getCode() {
    return code;
  }

  Map<int, Advertisement> getAdvertisementMap() {
    return advertisementMap;
  }

  FetchRecordsOfAdvertisementRsp.fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? -1;
    if (json.containsKey('body')) {
      var body = json['body'];
      if (body.containsKey('records_of_advertisement')) {
        final Map some = Map.from(body['records_of_advertisement']);
        some.forEach(
          (key, value) {
            advertisementMap[value['id']] = Advertisement(
              value['id'] ?? -1,
              value['name'] ?? "",
              value['title'] ?? "",
              value['place_of_origin'] ?? "",
              List<String>.from(value['selling_points'] as List),
              value['url'] ?? "",
              value['selling_price'] ?? "",
              value['description'] ?? "",
              value['status'] ?? -1,
              value['stock'] ?? -1,
              value['product_id'] ?? -1,
            );
          },
        );
      }
    }
  }
}

void fetchRecordsOfAdvertisement({
  required List<int> advertisementIdList,
}) {
  PacketClient packet = PacketClient.create();
  FetchRecordsOfAdvertisementReq req = FetchRecordsOfAdvertisementReq(advertisementIdList);
  packet.getHeader().setMajor(Major.admin);
  packet.getHeader().setMinor(Minor.admin.fetchRecordsOfAdvertisementReq);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
