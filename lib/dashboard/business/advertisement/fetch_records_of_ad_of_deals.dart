import 'dart:typed_data';
import 'package:flutter_framework/dashboard/model/ad_of_deals.dart';

import '../../../utils/convert.dart';
import 'package:flutter_framework/framework/packet_client.dart';
import '../../../common/route/major.dart';
import '../../../common/route/minor.dart';
import 'package:flutter_framework/runtime/runtime.dart';
import 'package:flutter_framework/common/code/code.dart';

class FetchRecordsOfADOfDealsReq {
  List<int> _advertisementIdList = [];

  FetchRecordsOfADOfDealsReq.construct({
    required List<int> advertisementIdList,
  }) {
    _advertisementIdList = advertisementIdList;
  }

  Map<String, dynamic> toJson() {
    return {"advertisement_id_list": _advertisementIdList};
  }
}

class FetchRecordsOfADOfDealsRsp {
  int _code = Code.internalError;
  List<int> _advertisementIdList = [];
  int _versionOfADOfDeals = -1;
  Map<int, ADOfDeals> _dataMap = {};

  int getCode() {
    return _code;
  }

  int getVersion() {
    return _versionOfADOfDeals;
  }

  List<int> getAdvertisementIdList() {
    return _advertisementIdList;
  }

  FetchRecordsOfADOfDealsRsp.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('code')) {
      _code = json['code'];
    }
    if (json.containsKey('body')) {
      Map<String, dynamic> body = json['body'];
      if (body.containsKey('version_of_ad_of_deals')) {
        _versionOfADOfDeals = body['version_of_ad_of_deals'];
      }
      if (body.containsKey('id_list_of_ad_of_deals')) {
        _advertisementIdList = List<int>.from(body['id_list_of_ad_of_deals'] as List);
      }
    }
  }
}

void fetchRecordsOfADOfDeals({
  required List<int> advertisementIdList,
}) {
  PacketClient packet = PacketClient.create();
  FetchRecordsOfADOfDealsReq req = FetchRecordsOfADOfDealsReq.construct(
    advertisementIdList: advertisementIdList,
  );
  packet.getHeader().setMajor(Major.advertisement);
  packet.getHeader().setMinor(Minor.advertisement.fetchRecordsOfADOfDealsReq_);
  packet.setBody(req.toJson());
  Runtime.wsClient.sendPacket(packet);
}
